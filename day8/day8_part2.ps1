using namespace system.collections.generic
$data = Get-Content -Path .\day8\input.txt

function manhattan {
    param(
        [string]$pos1,
        [string]$pos2
    )

    [int]$x1,[int]$y1 = $pos1-split ','
    [int]$x2,[int]$y2 = $pos2-split ','

    return [math]::abs($x1-$x2) + [math]::abs($y1-$y2)

}
$grid = [ordered]@{}
$antennas= [hashtable]::new([System.StringComparer]::Ordinal)
for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -ne '.') {
            $antennas[$data[$y][$x].tostring()] += @("$x,$y")
        }
        $grid.add("$x,$y", $data[$y][$x])
    }
}


$signals = [hashset[string]]@{}

foreach ($key in $antennas.Keys) {
    for ($i=0;$i -lt $antennas[$key].count-1 ;$i++){
        for ($j=$i+1;$j -lt $antennas[$key].count;$j++) {
            if ($i -eq $j) {continue}
                [int]$xa1,[int]$ya1 = $antennas[$key][$i] -split ','
                [int]$xa2,[int]$ya2 = $antennas[$key][$j] -split ','
                [void]$signals.add("$xa1,$ya1")
                [void]$signals.add("$xa2,$ya2")
                    [int]$xInc = [int]$xStep = [math]::abs($xa1-$xa2)
                    [int]$yInc = [int]$yStep = [math]::abs($ya1-$ya2)
                    $up=$down = $true

                    
                    
                while ($up -eq $true -or $down -eq $true) {

                    if (($ya1 - $yStep) -ge 0 -and ($ya1 -$ystep) -lt $data.count) {
                        if ($xa1 -lt $xa2) {
                            if (($xa1-$xstep) -ge 0 -and ($xa1-$xstep) -lt $data[0].Length) {
                                $signal1 = "$($xa1-$xStep),$($ya1-$ystep)"
                                [void]$signals.add($signal1)
                            }
                        }
                        else {
                            if (($xa1+$xstep) -ge 0 -and ($xa1+$xstep) -lt $data[0].Length) {
                                $signal1 = "$($xa1+$xStep),$($ya1-$ystep)"
                                [void]$signals.add($signal1)
                            }
                        }

                    }
                    else {
                        $up = $false
                    }
                    if (($ya2 + $yStep) -ge 0 -and ($ya2 +$ystep) -lt $data.count) {
                        if ($xa1 -lt $xa2) {
                            if (($xa2+$xstep) -ge 0 -and ($xa2+$xstep) -lt $data[0].Length) {
                                $signal2 = "$($xa2+$xStep),$($ya2+$ystep)"
                                [void]$signals.add($signal2)
                            }
                        }
                        else {
                            if (($xa2-$xstep) -ge 0 -and ($xa2-$xstep) -lt $data[0].Length) {
                                $signal2 = "$($xa2-$xStep),$($ya2+$ystep)"
                                [void]$signals.add($signal2)
                            }
                        }
                    }
                    else {
                        $down = $false
                    }
                    $xStep += $xInc
                    $yStep += $yInc
            }
        }
    }
}


for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -ne '.' -and !$signals.Contains("$x,$y")) {
            write-host "$($data[$y][$x])" -ForegroundColor Red -NoNewline
        }
        elseif ($data[$y][$x] -eq '.' -and $signals.Contains("$x,$y")) {
            write-host "#" -ForegroundColor Green -NoNewline
        }
        else {
            write-host "$($data[$y][$x])" -NoNewline
        }
    }
    write-host
}

$signals.Count