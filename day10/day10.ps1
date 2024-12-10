using namespace system.collections.generic
$data = Get-Content -Path .\day10\input.txt

$grid = [ordered]@{}
[list[string]]$startpositions = @()
for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -eq '0') {
            $startpositions.add("$x,$y")
        }
        $grid.add("$x,$y", $data[$y][$x])
    }
}

function test-paths {
    param(
        [int]$x,
        [int]$y,
        [hashtable]$visited = @{},
        [int]$maxX,
        [int]$maxY,
        [int]$currentNumber,
        [string]$direction
    )
    #Write-Host "Direction [$direction] position [$x,$y] nextnumber [$currentnumber]"
    if ($x -lt 0 -or $x -ge $maxX -or $y -lt 0 -or $y -ge $maxY) { return }
    
    if ($visited.ContainsKey("$x,$y")) {
        #Write-Host "already visited $x,$y $currentnumber"
        return
    }
    $visited["$x,$y"]++

    if ([int][string]$grid["$x,$y"] -eq 9) { return 1 }

    if ([int][string]$grid["$x,$y"] -eq $currentNumber) {

        $dir = @{
            up    = @(0, -1)
            down  = @(0, 1)
            left  = @(-1, 0)
            right = @(1, 0)
        }
        $dir.keys | ForEach-Object { 
            $key = $_
            $x1, $y1 = $dir[$key]
            if ([int][string]$grid["$($x + $x1),$($y + $y1)"] -eq ($currentNumber + 1) ) {
                test-paths -x ($x + $x1) -y ($y + $y1)-visited $visited -maxX $maxX -maxY $maxY -currentNumber ($currentNumber + 1) -direction $_
            }
        }
    }
}

$sum = for ($i = 0; $i -lt $startpositions.count; $i++) {
    [int]$x, [int]$y = $startpositions[$i] -split ','
    test-paths -x $x -y $y -visited @{} -maxX $data[0].Length -maxY $data.count -currentNumber 0 -direction 'start'
}

$sum | Measure-Object -Sum | ForEach-Object sum