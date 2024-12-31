using namespace system.collections.generic
$data = Get-Content -Path .\day16\input.txt

$maze = [ordered]@{}
$startposition = ''
$endposition = ''
for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -eq 'S') {
            $startposition = "$x,$y"
        }
        if ($data[$y][$x] -eq 'E') {
            $endposition = "$x,$y"
        }
        $maze.add("$x,$y", $data[$y][$x])
    }
}


$nodes = [ordered]@{}

$directions = @{
    n = 0, -1
    s = 0, 1
    e = 1, 0
    w = -1, 0
}

[PriorityQueue[[pscustomobject],[int]]]$queue = @{}


$queue.Enqueue([pscustomobject]@{
        Pos       = $startposition
        Cost      = 0
        Direction = 'e'
        Parent = $startposition
        Neigh = [list[pscustomobject]]@()
        visited = [hashset[string]]::new()
        isCluster = $false
    },0)

$parent = $startposition
[hashset[string]]$visited = @{}
$foundend = 0
$final = while ($queue.count -gt 0) {
    $current = $queue.Dequeue()
    $x, $y = $current.pos -split ',' -as [int[]]
    if ($maze[$current.pos] -eq '#' -or $visited.contains($current.pos)) {
    #if ($maze[$current.pos] -eq '#' -or $current.visited.contains($current.pos)) {

        continue
    }
    if ($maze[$current.pos] -eq 'E') {
        if ($foundend -gt 4) {
            break
        }
        $foundend++
        $current
        if ($nodes.Contains($current.pos)){
            continue
        }
        else {
            $current.Neigh.clear()
            $directions.keys | ForEach-Object {
                $key = $_
                if ($maze["$($x+$directions[$key][0]),$($y+$directions[$key][1])"] -eq '.') {
                    $current.neigh.add(
                        [pscustomobject]@{
                            Neigh = "$($x+$directions[$key][0]),$($y+$directions[$key][1])"
                            cost = 0
                        }
                    )
                }
            }
            $nodes.add("$x,$y", [pscustomobject]@{
                Pos       = $current.pos
                Cost      = $current.cost
                Direction = $current.Direction
                Parent = $current.parent
                Neigh = $current.Neigh
                visited = [hashset[string]]::new($current.visited)
                isCluster = $current.Neigh.count -ge 3 ? $true : $false
            })
            
        continue
    }
    }
    [void]$current.visited.add("$x,$y")
    [void]$visited.add("$x,$y")


    #lookaround to find a junctionpoint to maybe use in part2 to track multiple parts
    $neigh = 0
    $directions.Keys | ForEach-Object {
        $key = $_
        if ($maze["$($x+$directions[$key][0]),$($y+$directions[$key][1])"] -match 'S|\.|E') {
            #$current.neigh.add("$($x+$directions[$key][0]),$($y+$directions[$key][1])")
            if ($key -ne $current.direction) {
                $current.neigh.add(
                    [pscustomobject]@{
                        Neigh = "$($x+$directions[$key][0]),$($y+$directions[$key][1])"
                        cost = 1001
                    }
                    )
            } else {
                $current.neigh.add(
                    [pscustomobject]@{
                        Neigh = "$($x+$directions[$key][0]),$($y+$directions[$key][1])"
                        cost = 1
                    }
                    )
            }

            $neigh++
        }
    }

    if (-not $nodes.Contains("$x,$y")) {
    $nodes.add("$x,$y", 
        [pscustomobject]@{
            Pos       = $current.pos
            Cost      = $current.cost
            Direction = $current.Direction
            Parent = $current.Parent
            Neigh = $current.Neigh
            visited = [hashset[string]]::new($current.visited)
            isCluster = $current.Neigh.count -ge 3 ? $true : $false
        }
        )
    }

    $directions.keys | ForEach-Object {
        $key = $_
        if ($key -ne $current.direction) {
            $queue.Enqueue(
                [pscustomobject]@{
                    Pos       = "$($x+$directions[$key][0]),$($y+$directions[$key][1])"
                    Cost      = 1001+$current.cost
                    Direction = $_
                    Parent = "$x,$y"
                    Neigh = [list[psobject]]@()
                    visited = [hashset[string]]::new($current.visited)
                    isCluster = $current.Neigh.count -ge 3 ? $true : $false
                },(1001+$current.cost)
            )
        }
        else {
            $queue.Enqueue(
                [pscustomobject]@{
                    Pos       = "$($x+$directions[$key][0]),$($y+$directions[$key][1])"
                    Cost      = 1+$current.cost
                    Direction = $_
                    Parent = "$x,$y"
                    Neigh = [list[psobject]]@()
                    visited = [hashset[string]]::new($current.visited)
                    isCluster = $current.Neigh.count -ge 3 ? $true : $false
                },(1+$current.cost)
            )
        }
    }
}

for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        if ($final[0].visited.Contains("$x,$y")) {
            #Write-host $grid["$x,$y"] -NoNewline -ForegroundColor Red
            Write-host 'X' -NoNewline -ForegroundColor Red
        }
        elseif($visited.contains("$x,$y")) {
            write-host 'O' -NoNewline -ForegroundColor DarkBlue
        }
        else {
            write-host $maze["$x,$y"] -NoNewline
        }
    }
    write-host
}
$final.cost
