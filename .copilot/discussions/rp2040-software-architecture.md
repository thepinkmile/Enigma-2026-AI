DOCUMENT TITLE: Technical Supplement: Two-Phase Asynchronous Event Pipeline and .NET Architecture for Digital Enigma Subsystem

SECTION 1: Architectural Concept and Unified Stack
This document establishes the end-to-end design specification for a highly modular, event-driven, hardware-accelerated digital Enigma machine. The architecture decouples time-critical hardware sequencing from business domain modeling and terminal presentation.

Complete Software Stack Layout:
- Layer 4: .NET POS APP (Avalonia GUI Native Linux Runtime Process)
- Layer 3: DOCKER CONTAINER (C# .NET Domain Logic Engine)
- Layer 2: NATIVE C++ DAEMON (SCHED_FIFO Real-Time Loop)
- Layer 1: YOCTO LINUX KERNEL SPI HW DRIVER (via /dev/spidev0.0)

Layer 4 Details: An Avalonia UI cross-platform application compiling down to a native single-binary executable running directly on top of the Yocto Linux framebuffer or X11 surface.
Layer 3 Details: A .NET Core background service containing the mathematical Enigma configurations, state machines, and historical mapping variant lookup tables. It shares a common data contract layer (.dll assembly) with the frontend GUI app.
Layer 2 Details: A lightweight host-level binary running under a Linux Real-Time thread priority scheduler (SCHED_FIFO). It hosts a high-speed gRPC server endpoint to manage communication loopbacks inside the Docker network interface.

---

SECTION 2: Two-Phase Asynchronous Step Sequence
To accommodate mechanical and inductive latencies when a physical keypress is registered via the ENC_ACTIVE_N interrupt line, the software layer drops a purely sequential, single-shot execution profile in favor of a Two-Phase Asynchronous Pipeline. 

When a key is depressed, the system must trigger motor actuation globally across all stacked boards simultaneously, await stable positional settlement, and then execute the serialized cryptographic evaluation loop.

Processing Pipeline Progression:
- Initial Trigger: Physical key press causes ENC_ACTIVE_N to drop low.
- Phase 1: Actuation Event Broadcast. CM5 host pushes ActuationCommand down the gRPC stream. The C++ Daemon then broadcasts the pulse configuration down the SPI chain. The RP2040 Nodes latch their 5V MOSFETs to fire Rotor Servos simultaneously.
- Phase 2: Mechanical Settlement Delay. Hardware timers await physical servo translation. Microcontrollers confirm stable alignment.
- Phase 3: Combinatorial Cryptographic Evaluation Loop. System iterates Full-Duplex SPI cycles across 12 to 18 routing hops. EPM570 CPLDs instantly transform data combinatorially. Final transformed character index is returned to the .NET Engine.

---

SECTION 3: Core Contract Interface Definition (enigma.proto)

syntax = "proto3";

package enigma;

enum CommandType {
    TRIGGER_ACTUATION = 0;
    EXECUTE_CRYPTOGRAPHIC_HOP = 1;
}

message HardwareControlEvent {
    CommandType command = 1;
    bytes tx_buffer = 2;
}

message HardwareResponseEvent {
    bool actuation_complete = 1;
    bytes rx_buffer = 2;
}

service EnigmaHardwareBridge {
    rpc StreamHardwareCycle(stream HardwareControlEvent) returns (stream HardwareResponseEvent);
}

---

SECTION 4: Layer 2 Implementation: C++ Real-Time gRPC Server Daemon

#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <grpcpp/grpcpp.h>
#include "enigma.grpc.pb.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::ServerReaderWriter;
using grpc::Status;
using enigma::EnigmaHardwareBridge;
using enigma::HardwareControlEvent;
using enigma::HardwareResponseEvent;
using enigma::CommandType;

class EnigmaServiceImpl final : public EnigmaHardwareBridge::Service {
public:
    Status StreamHardwareCycle(ServerContext* context, 
                               ServerReaderWriter<HardwareResponseEvent, HardwareControlEvent>* stream) override {
        
        HardwareControlEvent control_event;
        
        while (stream->Read(&control_event)) {
            HardwareResponseEvent response_event;

            if (control_event.command() == CommandType::TRIGGER_ACTUATION) {
                std::vector<uint8_t> actuation_tx(24, 0xFF);
                
                usleep(45000); // 45ms mechanical buffer

                response_event.set_actuation_complete(true);
                stream->Write(response_event);
            } 
            else if (control_event.command() == CommandType::EXECUTE_CRYPTOGRAPHIC_HOP) {
                std::string tx_data = control_event.tx_buffer();
                std::vector<uint8_t> tx_buffer(tx_data.begin(), tx_data.end());
                
                std::string rx_data = "MOCK_24_BYTE_RESPONSE_DATA"; 

                response_event.set_actuation_complete(false);
                response_event.set_rx_buffer(rx_data);
                stream->Write(response_event);
            }
        }
        return Status::OK;
    }
};

void RunServer() {
    std::string server_address("127.0.0.1:50051");
    EnigmaServiceImpl service;
    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);
    std::unique_ptr<Server> server(builder.BuildAndStart());
    server->Wait();
}

int main() {
    RunServer();
    return 0;
}

---

SECTION 5: Layer 3 Implementation: .NET Core Domain Engine Service

using System;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Net.Client;
using Enigma;

namespace Enigma.Domain.Services;

public class CryptographicRoutingEngine
{
    private EnigmaHardwareBridge.EnigmaHardwareBridgeClient _grpcClient;
    private AsyncDuplexStreamingCall<HardwareControlEvent, HardwareResponseEvent> _hardwareStream;
    private TaskCompletionSource<bool> _actuationTaskTracker;
    private TaskCompletionSource<byte[]> _cryptographicTaskTracker;

    public CryptographicRoutingEngine()
    {
        var channel = GrpcChannel.ForAddress("http://docker.internal");
        _grpcClient = new EnigmaHardwareBridge.EnigmaHardwareBridgeClient(channel);
    }

    public async Task StartHardwarePipelineAsync()
    {
        _hardwareStream = _grpcClient.StreamHardwareCycle();

        _ = Task.Run(async () =>
        {
            try
            {
                await foreach (var responseEvent in _hardwareStream.ResponseStream.ReadAllAsync())
                {
                    if (responseEvent.ActuationComplete)
                    {
                        _actuationTaskTracker?.SetResult(true);
                    }
                    else
                    {
                        _cryptographicTaskTracker?.SetResult(responseEvent.RxBuffer.ToByteArray());
                    }
                }
            }
            catch (RpcException ex)
            {
                Console.WriteLine("Disconnection detected");
            }
        });
    }

    public async Task<string> ProcessGlobalKeyStrokeAsync(string inputCharacter)
    {
        _actuationTaskTracker = new TaskCompletionSource<bool>();
        
        var actuationCommand = new HardwareControlEvent { Command = CommandType.TriggerActuation };
        await _hardwareStream.RequestStream.WriteAsync(actuationCommand);

        await _actuationTaskTracker.Task;

        byte[] currentCryptoByteData = new byte[24];

        for (int hop = 0; hop < 18; hop++)
        {
            _cryptographicTaskTracker = new TaskCompletionSource<byte[]>();

            var hopCommand = new HardwareControlEvent
            {
                Command = CommandType.ExecuteCryptographicHop,
                TxBuffer = Google.Protobuf.ByteString.CopyFrom(currentCryptoByteData)
            };

            await _hardwareStream.RequestStream.WriteAsync(hopCommand);
            
            byte[] rawHardwareSnapshot = await _cryptographicTaskTracker.Task;
            currentCryptoByteData = rawHardwareSnapshot;
        }

        return "Z";
    }
}

---

SECTION 6: Peer Review Focus Areas

When submitting this architectural model to the repository for peer discussion, reviewers should analyze the following key criteria:

- Task Allocation Cost: Does the rapid creation and instantiation of TaskCompletionSource tracking layers during an 18-step loop create unnecessary garbage collection allocations on the .NET framework runtime within an embedded platform footprint?
- Mechanical Settlement Damping: Is the usleep blocking approach inside the C++ layer preferred over mapping a dedicated external physical limit-switch callback straight back through the RP2040 matrix?
- Bridge Network Serialization: Does streaming raw byte structures via Protocol Buffers circumvent default MTU constraints across the local virtual Docker network interfaces?
