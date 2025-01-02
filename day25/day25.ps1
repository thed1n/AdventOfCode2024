using namespace System.Collections.Generic
$data = get-content .\day25\input.txt -raw

[list[object]]$keys=@()
[list[object]]$locks = @()
$data -split '(?:\r?\n){2}' | % {
    $k = $_



    $k2 = $k -split '\r?\n'

        $type = [ordered]@{
            isKey = $true
        }
        for ($x = 0; $x -lt $k2[0].length; $x++) {
                
                for ($y =0;$y -lt $k2.count;$y++) { 

                    if ($y -eq 0 -and $x -eq 0 -and $k2[$y][$x] -eq '#') {
                        $type['isKey'] = $false
                        #write-host "lock"
                    }
                    if ($k2[$y][$x] -eq '#') {$type["$x"]++}
                    
                    #write-host $k2[$y][$x] -NoNewline
                }
                if (-not $type['isKey']) {
                    $type["$x"] = 5 -($type["$x"]-1)
                }
                else {
                    $type["$x"]--
                }
                #write-host
            }
            if ($type['isKey']) {
                $keys.add([pscustomobject]$type)
            }
            else {
                $locks.add([pscustomobject]$type)   
            }      
}

$validPairs = 0
foreach ($lock in $locks) {
    foreach($key in $keys) {
        $isMatch = $true
        for ($col = 0;$col -lt 5;$col++) {
            #$diff = 
            if ($lock.$col - $key.$col -lt 0) {
                #Write-host "no match overlap i column [$($col+1)]" #$($lock|convertto-json) $($key|convertto-json)"
                $isMatch = $false
                break
            }
            
        }
        if ($isMatch) {
            $validPairs++
        }
    }
}

$validPairs