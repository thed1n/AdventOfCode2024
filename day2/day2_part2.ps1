using namespace system.collections.generic
$data = Get-Content -Path .\day2\input.txt

function test-validity {
    [cmdletbinding()]
    param(
        [int[]]$levels
    )

    process {
        
        if ($levels[0] -ge $levels[1]) {
            for ($i = 0; $i -lt $levels.count - 1; $i++) {
                if ($levels[$i] - $levels[$i + 1] -gt 3 -or $levels[$i] - $levels[$i + 1] -le 0) {
                    return $false
                }
            }
            Write-Verbose "$($levels -join ',')"
            Write-Verbose $true
            return $true

        }

        if ($levels[0] -le $levels[1]) {
            for ($i = 0; $i -lt $levels.count - 1; $i++) {
                if ($levels[$i + 1] - $levels[$i] -gt 3 -or $levels[$i + 1] - $levels[$i] -le 0) {
                    return $false
                }
            }
            Write-Verbose "$($levels -join ',')"
            Write-Verbose $true
            return $true
        }

    }
}

$safe = 0

$data | ForEach-Object {
    [int[]]$levels = $_ -split '\s+'

    if ((test-validity $levels) -eq $false) {

            
        :outer for ($i = 0; $i -lt $levels.count; $i++) {
            $testrow = 0..$levels.count | Where-Object { $_ -ne $i }
            if (test-validity $levels[$testrow]) {
                #Write-Host "$($levels -join ',')" -ForegroundColor Cyan
                $safe++
                break outer
            }
        }
        
    }
    else {
        #Write-Host "$($levels -join ',')" -ForegroundColor Green
        $safe++
    }
}
[pscustomobject]@{
    part2 = $safe
}
