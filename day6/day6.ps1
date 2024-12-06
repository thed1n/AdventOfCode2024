using namespace system.collections.generic
$data = Get-Content -Path .\day6\test.txt


$startposition = ''
$grid = @{}
[hashset[string]]$visited=@{}

for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -eq '^') {
            $startposition = "$x,$y"
        }
        $grid.add("$x,$y", $data[$y][$x])
    }
}


$directions=[ordered]@{
    up = @(0,-1)
    down = @(0,1)
    left = @(-1,0)
    right = @(1,0)
}


#walk the grid
$dir = 'up'
[int]$xn,[int]$yn = $startposition -split ','
while ($true) {


    if ($xn -lt 0 -or $xn -gt $data[0].length -or $yn -lt 0 -or $yn -ge $data.count ) {
        break
    }
    
    [void]$visited.add("$xn,$yn")

    if ($grid["$($xn+$directions[$dir][0]),$($yn+$directions[$dir][1])"] -eq '#') {
        #turn
        switch ($dir) {
            'up' {$dir = 'right';break}
            'right' {$dir = 'down';break}
            'down' {$dir = 'left';break}
            'left' {$dir = 'up';break}
        }
    }
    #move
    $xn+=$directions[$dir][0]
    $yn+=$directions[$dir][1]

}

for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        if ($visited.Contains("$x,$y")) {
            #Write-host $grid["$x,$y"] -NoNewline -ForegroundColor Red
            Write-host 'X' -NoNewline -ForegroundColor Red

        }
        else {
            write-host $grid["$x,$y"] -NoNewline
        }
    }
    write-host
}

[pscustomobject]@{
    Part1 = $visited.count
}
