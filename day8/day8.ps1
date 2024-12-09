using namespace system.collections.generic
$data = Get-Content -Path .\day8\test.txt

function manhattan {
    param(
        [string]$pos1,
        [string]$pos2
    )

    [int]$x1,[int]$y1 = $pos1-split ','
    [int]$x2,[int]$y2 = $pos2-split ','

    return [math]::abs($x1-$x2) + [math]::abs($y1-$y2)

}
$grid = @{}
$antennas = @{}
for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        if ($data[$y][$x] -ne '.') {
            $antennas[$data[$y][$x].tostring()] += @("$x,$y")
        }
        $grid.add("$x,$y", $data[$y][$x])
    }
}



foreach ($key in $antennas.Keys) {

    for ($i=0;$i -lt $antennas[$key].count ;$i++){
        manhattan $antennas[$key][$i] -pos2 $antennas[$key][$i+1]
    }

}