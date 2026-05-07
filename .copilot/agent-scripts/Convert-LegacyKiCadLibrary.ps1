<#
.SYNOPSIS
    Converts KiCAD 4 legacy library format (.lib/.mod) to KiCAD 6 format (.kicad_sym/.kicad_mod).
.DESCRIPTION
    Reads symbols from SamacSys_Parts.lib and footprints from SamacSys_Parts.mod,
    converts them to KiCAD 6 s-expression format, and appends to the .kicad_sym file
    and writes individual .kicad_mod files to the .pretty directory.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ============================================================
# PATHS
# ============================================================
$root       = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$libPath    = Join-Path $root 'src\Electronics\Library\SamacSys_Parts.lib'
$modPath    = Join-Path $root 'src\Electronics\Library\SamacSys_Parts.mod'
$symPath    = Join-Path $root 'src\Electronics\Library\SamacSys_Parts.kicad_sym'
$prettyPath = Join-Path $root 'src\Electronics\Library\SamacSys_Parts.pretty'

# ============================================================
# TARGET SYMBOLS
# ============================================================
$targetSymbols = @(
    '10164227-1004A1RLF', '1211', '1674231-1', '2007435-1', '2195630015',
    '48406-0003', 'B3F-1070', 'B6B-PH-K-S_LF__SN_', 'CL21B106KAYQNNE',
    'ERF8-005-05.0-S-DV-L-K-TR', 'ERJ-2RKF33R0X', 'F52Q-1A7H1-11015',
    'PH1-05-UA', 'POE600F-12LB', 'RS1-05-G', 'SM04B-SRSS-TB_LF__SN_'
)

# Symbols whose footprint is already in .pretty (skip footprint conversion)
$skipFootprint = @('ERJ-2RKF33R0X')

# ============================================================
# HELPER FUNCTIONS
# ============================================================
function MilsToMm([double]$mils) {
    [Math]::Round($mils * 0.0254, 4)
}

function DirToAngle([string]$dir) {
    switch ($dir) {
        'R' { 0 }
        'L' { 180 }
        'U' { 270 }  # KiCAD4 Up = visual upward; after y-flip in schematic = 270° in KiCAD6
        'D' { 90 }   # KiCAD4 Down = visual downward; after y-flip = 90° in KiCAD6
        default { 0 }
    }
}

function ConvertElecType([string]$t) {
    switch ($t) {
        'I' { 'input' }
        'O' { 'output' }
        'B' { 'bidirectional' }
        'T' { 'tri_state' }
        'P' { 'passive' }
        'U' { 'unspecified' }
        'W' { 'power_in' }
        'w' { 'power_out' }
        'C' { 'open_collector' }
        'E' { 'open_emitter' }
        'N' { 'no_connect' }
        default { 'unspecified' }
    }
}

function EscStr([string]$s) {
    # Escape double-quotes for KiCAD s-expression strings
    $s -replace '"', '\"'
}

function FillCode([string]$c) {
    switch ($c) {
        'N'   { 'none' }
        'F'   { 'outline' }
        'f'   { 'background' }
        default { 'none' }
    }
}

# ============================================================
# SYMBOL CONVERSION
# ============================================================
function Convert-LibSymbol {
    param(
        [string]$compName,
        [string]$libText
    )

    # In .lib, some names have leading '1-' stripped (e.g. 1674231-1 stored as 1674231-1, not 1-1674231-1)
    $lookupName = $compName

    $escaped = [regex]::Escape($lookupName)
    # Match the first DEF block for this component
    $pattern  = "(?sm)^DEF $escaped .*?^ENDDEF"
    $match    = [regex]::Match($libText, $pattern)

    if (-not $match.Success) {
        Write-Warning "  Symbol '$compName' not found in .lib — skipping"
        return $null
    }
    $block = $match.Value
    $lines = $block -split "`r?`n"

    # --- Parse DEF line ---
    # DEF name ref 0 text_offset showPinName showPinNum num_units flag ref_type
    $defLine   = ($lines | Where-Object { $_ -match '^DEF ' } | Select-Object -First 1)
    $defParts  = $defLine -split '\s+'
    # $refPrefix = $defParts[2]  # e.g. J, U, R, C, S

    # --- Parse F fields ---
    $props = [ordered]@{}
    foreach ($line in $lines) {
        if ($line -notmatch '^F(\d+) ') { continue }
        $idx = [int]$Matches[1]

        # Extract the text value (first quoted string)
        if ($line -match '^F\d+ "([^"]*)"') {
            $val = $Matches[1]
        } else { $val = '' }

        # Determine field name
        if ($idx -eq 0) { $fieldName = 'Reference' }
        elseif ($idx -eq 1) { $fieldName = 'Value' }
        elseif ($idx -eq 2) { $fieldName = 'Footprint' }
        elseif ($idx -eq 3) { $fieldName = 'Datasheet' }
        else {
            # F4+ have a trailing "FieldName" at end of line
            if ($line -match '"([^"]+)"\s*$') { $fieldName = $Matches[1] }
            else { $fieldName = "F$idx" }
        }
        $props[$fieldName] = $val
    }

    # Add library prefix to footprint
    if ($props.Contains('Footprint') -and $props['Footprint'] -ne '') {
        $props['Footprint'] = "SamacSys_Parts:$($props['Footprint'])"
    }

    # --- Parse DRAW section ---
    $inDraw     = $false
    $pins       = [System.Collections.Generic.List[object]]::new()
    $polylines  = [System.Collections.Generic.List[object]]::new()
    $rectangles = [System.Collections.Generic.List[object]]::new()

    foreach ($line in $lines) {
        if ($line -eq 'DRAW')    { $inDraw = $true;  continue }
        if ($line -eq 'ENDDRAW') { $inDraw = $false; continue }
        if (-not $inDraw)        { continue }

        # X name num x y length direction namesize numsize unit convert elec_type
        if ($line -match '^X (\S+) (\S+) (-?[\d.]+) (-?[\d.]+) ([\d.]+) ([RLUD]) \d+ \d+ \d+ \d+ ([IOBTPUWwCEN])') {
            $pins.Add([PSCustomObject]@{
                Name     = $Matches[1]
                Number   = $Matches[2]
                X        = MilsToMm([double]$Matches[3])
                Y        = -(MilsToMm([double]$Matches[4]))  # negate y-axis
                Length   = MilsToMm([double]$Matches[5])
                Angle    = DirToAngle($Matches[6])
                ElecType = ConvertElecType($Matches[7])
            })
        }
        # S x1 y1 x2 y2 unit convert thickness fill
        elseif ($line -match '^S (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) \d+ \d+ [\d.]+ ([NFf])') {
            $rectangles.Add([PSCustomObject]@{
                X1   = MilsToMm([double]$Matches[1])
                Y1   = -(MilsToMm([double]$Matches[2]))
                X2   = MilsToMm([double]$Matches[3])
                Y2   = -(MilsToMm([double]$Matches[4]))
                Fill = FillCode($Matches[5])
            })
        }
        # P count unit convert thickness x1 y1 x2 y2 ... fill
        elseif ($line -match '^P (\d+) \d+ \d+ [\d.]+ (.+)') {
            $count  = [int]$Matches[1]
            $rest   = $Matches[2] -split '\s+'
            $coords = [System.Collections.Generic.List[object]]::new()
            for ($i = 0; $i -lt ($count * 2); $i += 2) {
                $coords.Add([PSCustomObject]@{
                    X = MilsToMm([double]$rest[$i])
                    Y = -(MilsToMm([double]$rest[$i + 1]))
                })
            }
            $fillChar = if ($rest.Count -gt ($count * 2)) { $rest[$count * 2] } else { 'N' }
            $polylines.Add([PSCustomObject]@{
                Points = $coords
                Fill   = FillCode($fillChar)
            })
        }
        # A (arc): skip for symbols — rarely used and complex to convert
        # C (circle): skip — uncommon
    }

    # ---- Build KiCAD 6 s-expression ----
    $sb = [System.Text.StringBuilder]::new()

    $sb.AppendLine("  (symbol `"$(EscStr $compName)`" (in_bom yes) (on_board yes)") | Out-Null

    # Properties
    $propOrder = @(
        'Reference', 'Value', 'Footprint', 'Datasheet', 'Description',
        'Height', 'Manufacturer_Name', 'Manufacturer_Part_Number',
        'Mouser Part Number', 'Mouser Price/Stock',
        'Arrow Part Number', 'Arrow Price/Stock'
    )
    $visibleProps = @('Reference', 'Value')
    $propId = 0
    foreach ($pn in $propOrder) {
        if (-not $props.Contains($pn)) { continue }
        $pv      = EscStr($props[$pn])
        $hidden  = if ($pn -notin $visibleProps) { "`n      (effects (font (size 1.27 1.27)) hide)" } else { '' }
        $sb.AppendLine("    (property `"$pn`" `"$pv`" (id $propId) (at 0 0 0)$hidden)") | Out-Null
        $propId++
    }

    # Sub-symbol _0_0 (graphical body — rectangles and polylines)
    $sb.AppendLine("    (symbol `"$(EscStr $compName)_0_0`"") | Out-Null
    foreach ($r in $rectangles) {
        $sb.AppendLine("      (rectangle (start $($r.X1) $($r.Y1)) (end $($r.X2) $($r.Y2))") | Out-Null
        $sb.AppendLine("        (stroke (width 0) (type default))") | Out-Null
        $sb.AppendLine("        (fill (type $($r.Fill)))") | Out-Null
        $sb.AppendLine("      )") | Out-Null
    }
    foreach ($p in $polylines) {
        $sb.AppendLine("      (polyline") | Out-Null
        $sb.AppendLine("        (pts") | Out-Null
        foreach ($pt in $p.Points) {
            $sb.AppendLine("          (xy $($pt.X) $($pt.Y))") | Out-Null
        }
        $sb.AppendLine("        )") | Out-Null
        $sb.AppendLine("        (stroke (width 0) (type default))") | Out-Null
        $sb.AppendLine("        (fill (type $($p.Fill)))") | Out-Null
        $sb.AppendLine("      )") | Out-Null
    }
    $sb.AppendLine("    )") | Out-Null

    # Sub-symbol _0_1 (pins)
    $sb.AppendLine("    (symbol `"$(EscStr $compName)_0_1`"") | Out-Null
    foreach ($pin in $pins) {
        $pinName = EscStr($pin.Name)
        $sb.AppendLine("      (pin $($pin.ElecType) line (at $($pin.X) $($pin.Y) $($pin.Angle)) (length $($pin.Length))") | Out-Null
        $sb.AppendLine("        (name `"$pinName`" (effects (font (size 1.27 1.27))))") | Out-Null
        $sb.AppendLine("        (number `"$($pin.Number)`" (effects (font (size 1.27 1.27))))") | Out-Null
        $sb.AppendLine("      )") | Out-Null
    }
    $sb.AppendLine("    )") | Out-Null

    $sb.AppendLine("  )") | Out-Null

    return $sb.ToString()
}

# ============================================================
# FOOTPRINT CONVERSION
# ============================================================
function Convert-ModFootprint {
    param(
        [string]$fpName,      # e.g. "B3F1060"
        [string]$modText,
        [string]$symName      # e.g. "B3F-1070" (for description)
    )

    $escaped = [regex]::Escape($fpName)
    $pattern = "(?s)\`$MODULE $escaped.*?\`$EndMODULE $escaped"
    $match   = [regex]::Match($modText, $pattern)

    if (-not $match.Success) {
        Write-Warning "  Footprint '$fpName' not found in .mod — skipping"
        return $null
    }

    $block = $match.Value
    $lines = $block -split "`r?`n"

    # --- Parse module header ---
    $desc = ''
    $tags = ''
    $attr = 'through_hole'  # default

    foreach ($line in $lines) {
        if ($line -match '^Cd (.+)') { $desc = $Matches[1].Trim() }
        if ($line -match '^Kw (.+)') { $tags = $Matches[1].Trim().ToLower() }
        if ($line -match '^At SMD')  { $attr = 'smd' }
    }

    # --- Classify DS drawing lines ---
    # Layer 21 = F.SilkS
    # Layer 24 = Dwgs.User → split into F.Fab (inner/smaller) and F.CrtYd (outer/larger)
    $silkLines = [System.Collections.Generic.List[object]]::new()
    $layer24   = [System.Collections.Generic.List[object]]::new()

    foreach ($line in $lines) {
        if ($line -match '^DS (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) ([\d.]+) (\d+)') {
            $x1 = [double]$Matches[1]; $y1 = [double]$Matches[2]
            $x2 = [double]$Matches[3]; $y2 = [double]$Matches[4]
            $w  = [double]$Matches[5]; $layer = [int]$Matches[6]
            $obj = [PSCustomObject]@{ X1=$x1; Y1=$y1; X2=$x2; Y2=$y2; W=$w; Layer=$layer }
            if ($layer -eq 21) { $silkLines.Add($obj) }
            elseif ($layer -eq 24) { $layer24.Add($obj) }
            # Layer 28 (Edge.Cuts) and others ignored for footprint body
        }
    }

    # For layer 24 lines: determine bounding boxes and classify as F.Fab or F.CrtYd
    # Build list of distinct bounding boxes by clustering lines with similar bounds
    $fabLines  = [System.Collections.Generic.List[object]]::new()
    $crtLines  = [System.Collections.Generic.List[object]]::new()

    if ($layer24.Count -gt 0) {
        # Compute min/max of all coords per "group" — use line width as discriminator:
        # Standard: F.CrtYd = 0.05mm width, F.Fab = 0.1 or 0.2mm width
        # If widths don't distinguish, use bounding box area (larger = CrtYd)
        $groups = $layer24 | Group-Object -Property W

        if ($groups.Count -ge 2) {
            # Sort groups by average bounding box area; smallest = F.Fab, largest = F.CrtYd
            $scored = foreach ($g in $groups) {
                $minX = ($g.Group | Measure-Object -Property X1 -Minimum).Minimum
                $maxX = ($g.Group | Measure-Object -Property X2 -Maximum).Maximum
                $minY = ($g.Group | Measure-Object -Property Y1 -Minimum).Minimum
                $maxY = ($g.Group | Measure-Object -Property Y2 -Maximum).Maximum
                $area = [Math]::Abs(($maxX - $minX) * ($maxY - $minY))
                [PSCustomObject]@{ Group=$g; Area=$area }
            }
            $sorted = $scored | Sort-Object -Property Area
            foreach ($item in $sorted[0].Group.Group) { $fabLines.Add($item) }
            for ($gi = 1; $gi -lt $sorted.Count; $gi++) {
                foreach ($item in $sorted[$gi].Group.Group) { $crtLines.Add($item) }
            }
        } elseif ($groups.Count -eq 1) {
            # Only one group; use 0.05 width heuristic
            $w = [double]($groups[0].Name)
            if ($w -le 0.05) {
                foreach ($item in $groups[0].Group) { $crtLines.Add($item) }
            } else {
                foreach ($item in $groups[0].Group) { $fabLines.Add($item) }
            }
        }
    }

    # --- Parse arcs (DA) ---
    $arcs = [System.Collections.Generic.List[object]]::new()
    foreach ($line in $lines) {
        if ($line -match '^DA (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) ([\d.]+) (\d+)') {
            $cx = [double]$Matches[1]; $cy = [double]$Matches[2]
            $sx = [double]$Matches[3]; $sy = [double]$Matches[4]
            $angleDeci = [double]$Matches[5]  # in 0.1 degrees
            $w  = [double]$Matches[6]; $layer = [int]$Matches[7]
            $arcs.Add([PSCustomObject]@{ Cx=$cx; Cy=$cy; Sx=$sx; Sy=$sy; AngleDeci=$angleDeci; W=$w; Layer=$layer })
        }
    }

    # --- Parse pads ---
    $pads = [System.Collections.Generic.List[object]]::new()
    $inPad = $false
    $currentPad = $null

    foreach ($line in $lines) {
        if ($line -eq '$PAD') {
            $inPad = $true
            $currentPad = @{ Num=''; Shape='C'; Sx=1.0; Sy=1.0; Rot=0.0; X=0.0; Y=0.0; Dr=0.0; Type='thru_hole'; IsNPTH=$false }
            continue
        }
        if ($line -eq '$EndPAD') {
            if ($inPad -and $currentPad -ne $null) { $pads.Add($currentPad) }
            $inPad = $false; $currentPad = $null
            continue
        }
        if (-not $inPad) { continue }

        # Sh "num" shape sx sy mirror_x mirror_y rotation
        if ($line -match '^Sh "([^"]*)" ([RCOTrco]) ([\d.]+) ([\d.]+) \S+ \S+ (-?[\d.]+)') {
            $currentPad['Num']   = $Matches[1]
            $currentPad['Shape'] = $Matches[2].ToUpper()
            $currentPad['Sx']    = [double]$Matches[3]
            $currentPad['Sy']    = [double]$Matches[4]
            $currentPad['Rot']   = [double]$Matches[5] / 10.0  # deciseconds → degrees
        }
        # Dr drill_diam off_x off_y
        if ($line -match '^Dr ([\d.]+) (-?[\d.]+) (-?[\d.]+)') {
            $currentPad['Dr'] = [double]$Matches[1]
        }
        # At type buried layermask
        if ($line -match '^At (\S+) ') {
            $t = $Matches[1]
            if ($t -eq 'SMD')  { $currentPad['Type'] = 'smd' }
            elseif ($t -eq 'HOLE') { $currentPad['Type'] = 'np_thru_hole'; $currentPad['IsNPTH'] = $true }
            else { $currentPad['Type'] = 'thru_hole' }
        }
        # Po x y
        if ($line -match '^Po (-?[\d.]+) (-?[\d.]+)') {
            $currentPad['X'] = [double]$Matches[1]
            $currentPad['Y'] = [double]$Matches[2]
        }
    }

    # --- Build KiCAD 6 .kicad_mod ---
    $sb = [System.Text.StringBuilder]::new()

    $sb.AppendLine("(footprint `"$fpName`"") | Out-Null
    $sb.AppendLine("  (version 20211014)") | Out-Null
    $sb.AppendLine("  (generator pcbnew)") | Out-Null
    $attrStr = if ($attr -eq 'smd') { '(attr smd)' } else { '' }
    if ($attrStr) { $sb.AppendLine("  $attrStr") | Out-Null }
    $sb.AppendLine("  (layer `"F.Cu`")") | Out-Null
    if ($desc) { $sb.AppendLine("  (descr `"$(EscStr $desc)`")") | Out-Null }
    if ($tags) { $sb.AppendLine("  (tags `"$(EscStr $tags)`")") | Out-Null }

    # Reference and value text
    $sb.AppendLine("  (fp_text reference `"REF**`" (at 0 -3) (layer `"F.SilkS`")") | Out-Null
    $sb.AppendLine("    (effects (font (size 1.27 1.27) (thickness 0.15)))") | Out-Null
    $sb.AppendLine("  )") | Out-Null
    $sb.AppendLine("  (fp_text value `"$fpName`" (at 0 3) (layer `"F.Fab`") hide") | Out-Null
    $sb.AppendLine("    (effects (font (size 1.27 1.27) (thickness 0.15)))") | Out-Null
    $sb.AppendLine("  )") | Out-Null

    # Fab layer lines (F.Fab)
    foreach ($l in $fabLines) {
        $sb.AppendLine("  (fp_line (start $($l.X1) $($l.Y1)) (end $($l.X2) $($l.Y2)) (layer `"F.Fab`") (width $($l.W)))") | Out-Null
    }

    # Courtyard lines (F.CrtYd)
    foreach ($l in $crtLines) {
        $sb.AppendLine("  (fp_line (start $($l.X1) $($l.Y1)) (end $($l.X2) $($l.Y2)) (layer `"F.CrtYd`") (width 0.05))") | Out-Null
    }

    # Silkscreen lines (F.SilkS)
    foreach ($l in $silkLines) {
        $sb.AppendLine("  (fp_line (start $($l.X1) $($l.Y1)) (end $($l.X2) $($l.Y2)) (layer `"F.SilkS`") (width $($l.W)))") | Out-Null
    }

    # Arcs
    foreach ($arc in $arcs) {
        $layerName = switch ($arc.Layer) {
            21 { 'F.SilkS' }
            24 { 'F.Fab' }
            default { 'F.SilkS' }
        }
        # Compute end and mid points
        $cx = $arc.Cx; $cy = $arc.Cy
        $sx = $arc.Sx; $sy = $arc.Sy
        $angleDeg = $arc.AngleDeci / 10.0

        $dx = $sx - $cx; $dy = $sy - $cy
        $radius = [Math]::Sqrt($dx * $dx + $dy * $dy)

        if ($radius -gt 0) {
            $startAngleRad = [Math]::Atan2($dy, $dx)
            $angleRad      = $angleDeg * [Math]::PI / 180.0
            $midAngleRad   = $startAngleRad + $angleRad / 2.0
            $endAngleRad   = $startAngleRad + $angleRad

            $midX = [Math]::Round($cx + $radius * [Math]::Cos($midAngleRad), 4)
            $midY = [Math]::Round($cy + $radius * [Math]::Sin($midAngleRad), 4)
            $endX = [Math]::Round($cx + $radius * [Math]::Cos($endAngleRad), 4)
            $endY = [Math]::Round($cy + $radius * [Math]::Sin($endAngleRad), 4)

            $sb.AppendLine("  (fp_arc (start $sx $sy) (mid $midX $midY) (end $endX $endY) (layer `"$layerName`") (width $($arc.W)))") | Out-Null
        }
    }

    # Pads
    foreach ($pad in $pads) {
        $padType  = $pad['Type']
        $shape    = switch ($pad['Shape']) {
            'R' { 'rect' }
            'C' { 'circle' }
            'O' { 'oval' }
            default { 'circle' }
        }
        $num  = EscStr($pad['Num'])
        $x    = [Math]::Round($pad['X'], 4)
        $y    = [Math]::Round($pad['Y'], 4)
        $sx   = [Math]::Round($pad['Sx'], 4)
        $sy   = [Math]::Round($pad['Sy'], 4)
        $dr   = [Math]::Round($pad['Dr'], 4)
        $rot  = $pad['Rot']

        $atPart   = if ($rot -ne 0) { "(at $x $y $rot)" } else { "(at $x $y)" }
        $sizePart = "(size $sx $sy)"

        if ($padType -eq 'smd') {
            $layers = '(layers "F.Cu" "F.Paste" "F.Mask")'
            $sb.AppendLine("  (pad `"$num`" smd $shape $atPart $sizePart $layers)") | Out-Null
        }
        elseif ($padType -eq 'np_thru_hole') {
            $drillPart = "(drill $dr)"
            $layers = '(layers "*.Cu" "*.Mask")'
            $sb.AppendLine("  (pad `"`" np_thru_hole circle $atPart $sizePart $drillPart $layers)") | Out-Null
        }
        else {
            # thru_hole
            $drillStr  = if ($dr -gt 0) { "(drill $dr)" } else { "(drill $sx)" }
            $layers    = '(layers "*.Cu" "*.Mask")'
            $sb.AppendLine("  (pad `"$num`" thru_hole $shape $atPart $sizePart $drillStr $layers)") | Out-Null
        }
    }

    $sb.AppendLine(")") | Out-Null

    return $sb.ToString()
}

# ============================================================
# MAIN
# ============================================================
Write-Host "=== KiCAD 4 → KiCAD 6 Library Migration ===" -ForegroundColor Cyan

$libText = Get-Content $libPath -Raw
$modText = Get-Content $modPath -Raw

# Read current .kicad_sym — strip the final closing ')'
$symContent = Get-Content $symPath -Raw
if ($symContent.TrimEnd() -notmatch '\)$') {
    Write-Error ".kicad_sym does not end with ')' — aborting"
    exit 1
}
# Remove trailing whitespace + final ')'
$symBase = $symContent.TrimEnd()
$symBase = $symBase.Substring(0, $symBase.LastIndexOf(')'))

$newSymbols = [System.Text.StringBuilder]::new()
$convertedSyms    = 0
$convertedFps     = 0
$skippedSyms      = 0
$skippedFps       = 0

foreach ($sym in $targetSymbols) {
    Write-Host "`nProcessing: $sym" -ForegroundColor Yellow

    # ---- Symbol ----
    $symBlock = Convert-LibSymbol -compName $sym -libText $libText
    if ($symBlock) {
        $newSymbols.Append($symBlock) | Out-Null
        Write-Host "  [SYM] Converted '$sym'" -ForegroundColor Green
        $convertedSyms++
    } else {
        $skippedSyms++
    }

    # ---- Footprint ----
    if ($sym -in $skipFootprint) {
        Write-Host "  [FP]  Skipped '$sym' — footprint already in .pretty" -ForegroundColor DarkGray
        $skippedFps++
        continue
    }

    # Get footprint name from .lib F2 field
    $escaped = [regex]::Escape($sym)
    $fpBlock = [regex]::Match($libText, "(?s)^DEF $escaped .*?^ENDDEF", 'Multiline')
    if (-not $fpBlock.Success) { continue }
    $f2match = [regex]::Match($fpBlock.Value, 'F2 "([^"]*)"')
    if (-not $f2match.Success -or $f2match.Groups[1].Value -eq '') {
        Write-Host "  [FP]  No footprint ref in F2 for '$sym'" -ForegroundColor DarkYellow
        continue
    }
    $fpName = $f2match.Groups[1].Value

    $outFile = Join-Path $prettyPath "$fpName.kicad_mod"
    if (Test-Path $outFile) {
        Write-Host "  [FP]  '$fpName.kicad_mod' already exists — skipping" -ForegroundColor DarkGray
        $skippedFps++
        continue
    }

    $fpContent = Convert-ModFootprint -fpName $fpName -modText $modText -symName $sym
    if ($fpContent) {
        Set-Content -Path $outFile -Value $fpContent -Encoding UTF8
        Write-Host "  [FP]  Written '$fpName.kicad_mod'" -ForegroundColor Green
        $convertedFps++
    } else {
        $skippedFps++
    }
}

# ---- Append new symbols to .kicad_sym ----
if ($convertedSyms -gt 0) {
    $finalContent = $symBase + "`n" + $newSymbols.ToString().TrimEnd() + "`n)"
    Set-Content -Path $symPath -Value $finalContent -Encoding UTF8
    Write-Host "`n[SYM] Wrote $convertedSyms new symbols to SamacSys_Parts.kicad_sym" -ForegroundColor Cyan
}

Write-Host "`n=== Migration complete ===" -ForegroundColor Cyan
Write-Host "  Symbols  converted : $convertedSyms"
Write-Host "  Symbols  skipped   : $skippedSyms"
Write-Host "  Footprints written : $convertedFps"
Write-Host "  Footprints skipped : $skippedFps"
