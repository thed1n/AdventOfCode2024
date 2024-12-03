using namespace system.collections.generic
$data = Get-Content -Path .\day3\input.txt

$sum = 0
$data | select-string -Pattern 'mul\(\d+,\d+\)' -AllMatches | % {
    $_.Matches.value -replace 'mul\(|\)$' | % {
        $a,$b = $_ -split ','
        $sum+= $a*$b
    }
}

$sumpt2 = 0
$processData = $true
$data | select-string -Pattern 'do\(\)|don.t\(\)|mul\(\d+,\d+\)' -AllMatches | % {
    $_.Matches.Value | % {
        if ($_ -match 'don.t\(\)') {
            $processData = $false
        }
        if ($_ -match 'do\(\)') {
            $processData = $true
        }
        if ($processData -and $_ -match 'mul') {
            $n = $_ -replace 'mul\(|\)$'
            $a,$b = $n -split ','
            $sumpt2+= $a*$b
        }
    }
}

[PSCustomObject]@{
    part1 = $sum
    part2 = $sumpt2
}
