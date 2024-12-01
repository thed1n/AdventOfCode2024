using namespace system.collections.generic
$data = Get-Content -Path .\day1\input.txt
$leftList = [list[int]]::new()
$rightList = [list[int]]::new()

$data | ForEach-Object {
    $l, $r = $_ -split '\s+' 
    $leftList.add($l)
    $rightList.add($r)
}

$leftList.sort()
$rightList.sort()

$rightMap = @{}
$rightList | ForEach-Object {
    if ($rightMap.ContainsKey($_)) {
        $rightMap[$_]++
    }
    else {
        $rightMap.add($_, 1)
    }
}

[int]$diff = 0
[int]$similarityScore = 0
for ($i = 0; $i -lt $leftList.count; $i++) {
    $diff += [math]::abs($leftList[$i] - $rightList[$i])

    if ($rightMap.ContainsKey($leftList[$i])) {
        $similarityScore += ($leftlist[$i] * $rightMap[$leftlist[$i]])
    }

}

[pscustomobject]@{
    Part1 = $diff
    Part2 = $similarityScore
}