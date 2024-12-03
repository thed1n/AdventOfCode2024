using namespace system.collections.generic
$data = Get-Content -Path .\day2\input.txt

$safeLevels = 0
$data| % {
    [int[]]$levels = $_ -split '\s+'
    $less = $true
    $more = $true
    for ($i=0;$i -lt ($levels.count - 1);$i++) {

        if ($less -eq $true -and $levels[$i] -lt $levels[($i+1)]) {
            if ($levels[($i+1)]-$levels[$i] -lt 4) {
                $less = $true
                $more = $false
            }
            else {
                $less = $false
            }
        }
        else {
            $less = $false
        }
        if ($more -eq $true -and $levels[$i] -gt $levels[($i+1)]) {
            if ($levels[$i] - $levels[($i+1)] -lt 4) {
                $more = $true
                $less = $false
            }
            else {
                $more = $false
            }

        }
        else {
            $more = $false
        }
    }

    if ($less -or $more) {
        # if ($less) {
        #     write-host $($levels -join ',') -ForegroundColor Green
        # }
        # if ($more) {
        #     write-host $($levels -join ',') -ForegroundColor red
        # }
        $safeLevels++
    } 

}

$safeLevels