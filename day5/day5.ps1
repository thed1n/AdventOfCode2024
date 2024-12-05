using namespace system.collections.generic
$data = Get-Content -Path .\day5\input.txt

[list[int[]]]$pages = @()
[list[int[]]]$unOrderedPages = @()
$printOrder = @{}

$data | ForEach-Object {

    if ([string]::IsNullOrEmpty($_)) { return }

    if ($_ -match '\|') {
        [int]$leading, [int]$following = $_ -split '\|'
        if ($printOrder.ContainsKey($leading)) {
            [void]$printOrder[$leading].add($following)
        }
        else {
            $printOrder.add($leading, [hashset[int]]::new())
            [void]$printOrder[$leading].add($following)
        }
    }
    else {
        $p = $_ -split ',' -as [int[]]
        $pages.add($p)
    }
}

$sum = 0
foreach ($row in $pages) {
$inOrder = $true    
    for ($i = 1; $i -lt $row.count; $i++) {

            $nr = $row[$i]
            if ($printOrder.ContainsKey($row[$i - 1])) {
                if (!$printOrder[$row[$i - 1]].Contains($nr)) {
                    $unOrderedPages.add($row)
                    $inOrder =$false
                    break
                }
            }
    }
    if ($inOrder) {
        $sum += $row[[math]::floor($row.count / 2)]
    }
}

$sum2 = 0
foreach ($unsortedPage in $unOrderedPages ) {
$inOrder = $true
while ($true) {
    $changed = $false
    for ($i = 1; $i -lt $unsortedPage.count; $i++) {
        #iterate through until its sorted according to the rules
        if ($printOrder.ContainsKey($unsortedPage[$i]) -and $printorder[$unsortedPage[$i]].Contains($unsortedPage[$i - 1])) {
            $tempnr = $unsortedPage[$i - 1]
            $unsortedPage[$i - 1] = $unsortedPage[$i]
            $unsortedPage[$i] = $tempnr
            $changed = $true
        }
    }
    if ($changed -eq $false) {
        break
    }
}
        $sum2 += $unsortedPage[[math]::floor($unsortedPage.count / 2)]
}

[pscustomobject]@{
    Part1 = $sum
    Part2 = $sum2
}