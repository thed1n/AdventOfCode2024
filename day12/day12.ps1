using namespace system.collections.generic
$data = Get-Content -Path .\day12\input.txt

class area {
    [hashset[string]]$area = @{}
    [int]$perimeter = 0
    [string]$region

    [int] sum () {
        return $this.perimeter*$this.area.count
    }
}

[list[area]]$areas = @()

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

$dir = @(@(0,1),@(0,-1),@(1,0),@(-1,0))

[hashset[string]]$visited = @{}
[queue[list[int]]]$queue = @{}

for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if (-not $visited.contains("$x,$y")) {
            $current = $grid["$x,$y"]
            [void]$visited.add("$x,$y")

            $area = [area]::new()
            [void]$area.area.add("$x,$y")
            $area.region = $current

            #enqueue nearby nodes
            $dir | % {
                $xn,$yn = $_
                $queue.Enqueue(@($($x+$xn),$($y+$yn)))
            }

            #start BFS to look for neigh
            while ($queue.Count -gt 0) {

                $xn,$yn = $queue.Dequeue()
                if ($area.area.contains("$xn,$yn")) {
                    continue
                }

                if ($grid["$xn,$yn"] -eq $current) {
                    [void]$area.area.add("$xn,$yn")
                    [void]$visited.add("$xn,$yn")

                    $dir | % {
                        $xneigh,$yneigh = $_
                        $queue.Enqueue(@($($xn+$xneigh),$($yn+$yneigh)))
                    }
                }
                else {
                    $area.perimeter++
                }
            }
            $areas.add($area)

        }
    }
}

$sum = 0

$areas| % {
    $sum += $_.sum()
}

$sum