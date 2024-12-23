using namespace system.collections.generic
$data = Get-Content -Path .\day14\input.txt
$test = $false
$robots = @{}
for ($r = 0; $r -lt $data.count; $r++) {
    [int]$xr, [int]$yr, [int]$xm, [int]$ym = $data[$r] -split '\s' -replace '\w=' -split ','
    $robots.add($r,
        [pscustomobject]@{
            pos = @($xr, $yr)
            dir = @($xm, $ym)
        }
    )
}
function draw {
    param (
        [switch]$rob,
        [switch]$result
    )
    $newgrid = @{}
    if ($rob) {

        foreach ($rkey in $robots.Keys) {
            $newgrid["$($robots[$rkey].pos -join ',')"]++
        }
        [int]$squarex = [math]::floor($bwidth/2)
        [int]$squarey = [math]::floor($bhigth/2)
        :outer for ($y = 0; $y -lt $bhigth; $y++) {
            for ($x = 0; $x -lt $bwidth; $x++) {
                if ($result -and $x -eq $squarex) { Write-Host ' ' -NoNewline; continue}
                if ($result -and $y -eq $squarey) {write-host; continue outer}
                
                if ($newgrid["$x,$y"]) {
                    Write-Host $newgrid["$x,$y"] -ForegroundColor Yellow -NoNewline
                    continue
                }
                Write-Host '.' -NoNewline
            }
            Write-Host
        }
        return
    }
    for ($y = 0; $y -lt $bhigth; $y++) {
        for ($x = 0; $x -lt $bwidth; $x++) {
            if ("$($robots[$key].pos-join',')" -eq "$x,$y") {
                Write-Host 'R' -ForegroundColor Yellow -NoNewline
                continue
            }
            Write-Host $bathroom["$x,$y"] -NoNewline
        }
        Write-Host
    }

}

if ($test) {
    $bwidth = 11
    $bhigth = 7
} else {
    $bwidth = 101
    $bhigth = 103
}

$bathroom = @{}
for ($y = 0; $y -lt $bhigth; $y++) {
    for ($x = 0; $x -lt $bwidth; $x++) {
        $bathroom["$x,$y"] = '.'
    }
}


[int]$squarex = [math]::floor($bwidth/2)
[int]$squarey = [math]::floor($bhigth/2)
for ($i = 1;; $i++) {
if ($i -gt 10000) { break}
    foreach ($key in $robots.Keys) {
        [int]$xmove = $robots[$key].pos[0] + $robots[$key].dir[0]
        [int]$ymove = $robots[$key].pos[1] + $robots[$key].dir[1]

        if ($ymove -lt 0) {
            $ymove = $bhigth + $ymove
        }
        if ($xmove -lt 0) {
            $xmove = $bwidth + $xmove
        }
        if ($ymove -ge $bhigth) {
            $ymove = $ymove - $bhigth
        }
        if ($xmove -ge $bwidth) {
            $xmove = $xmove - $bwidth
        }
        $robots[$key].pos[0] = $xmove
        $robots[$key].pos[1] = $ymove
    }
    $resultgrid = @{}
    foreach ($rkey in $robots.Keys) {
        $resultgrid["$($robots[$rkey].pos -join ',')"]++
    }

        if (2 -notin $resultgrid.Values) {

            write-host "$i" -ForegroundColor Red
            draw -rob
            break
        }
}

[pscustomobject]@{
    Part2 = $i
}
