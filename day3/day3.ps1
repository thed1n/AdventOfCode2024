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
$data | select-string -Pattern 'do\(\)|don.t\(\)|mul\(\d+,\d+\)' -AllMatches | % {
    $_.Matches.Value | % {
        if ($_ -match 'don.t\(\)') {
            $process = $false
        }
        if ($_ -match 'do\(\)') {
            $process = $true
        }
        if ($process -and $_ -match 'mul') {
            $n = $_ -replace 'mul\(|\)$'
            $a,$b = $n -split ','
            $sumpt2+= $a*$b
        }
    }
}

$sum
$sumpt2