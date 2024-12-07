using namespace system.collections.generic
$data = Get-Content -Path .\day7\input.txt

[list[pscustomobject]]$equations = @()
$data | % {
    [uint64]$sum,[uint64[]]$operators = $_ -split ': ' -split '\s'
    $equations.add(
        [pscustomobject]@{
            Sum = $sum
            Operators = $operators
            Hit = 0
        }
    )
}

function test-equation {
    [cmdletbinding()]
    param (
        [uint64[]]$op,
        [int]$position,
        [uint64]$sum,
        [uint64]$result
    )
        if ($position -ge $op.count) {
            return
        }

        [uint64]$add = $sum + $op[$position]
        [uint64]$multiply = $sum * $op[$position]
        if ($result -eq $add -and $position -eq $op.count-1) { 
            write-verbose "add $($op-join ' ') pos [$position] sum [$add] -result [$result]"
            return $true
        }
        elseif ($result -eq $multiply -and $position -eq $op.count-1) {
            write-verbose "mult $($op-join ' ') pos [$position] sum [$multiply] -result [$result]"
            return $true
        }
        
        $position++

        if ($add -le $result ) {
            test-equation -sum $add -result $result -position $position -op $op
        }
        if ($multiply -le $result) {
            test-equation -sum $multiply -result $result -position $position -op $op
        }
        
}

foreach ($op in $equations) {
    if (test-equation -op $op.Operators -position 1 -sum $op.Operators[0] -result $op.Sum -Verbose) {
        $op.hit++
    }
}


[uint64]$sum = 0 
$equations | ? hit -gt 0 | select -exp sum |% {
    $sum+=$_
}
[pscustomobject]@{
    Sum = $sum
}
