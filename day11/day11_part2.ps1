using namespace system.collections.generic
$data = Get-Content -Path .\day11\input.txt

class StoneLine {
    [hashtable]$cache = @{}
    [hashtable]$stone = @{}
    [uint64]$result = 0

    StoneLine ([string]$data) {
        $data -split ' ' | ForEach-Object {
            $this.stone[[uint64]$_]++
        }
    }

    Add ([string]$data) {
        $this.cache.clear()
        $this.stone.clear()
        $this.result = 0
        $data -split ' ' | ForEach-Object {
            $this.stone[[uint64]$_]++
        }
    }

    Blink ([int]$rounds) {

        1..$rounds | ForEach-Object {

            $this.cache = $this.stone.Clone()
            $this.stone.clear()
            foreach ($key in $this.cache.keys) {
                #write-host $key
                switch ($key) {
                    {$_ -eq 0} {
                        #write-host "is zero? $_ $($key.gettype())  $($key+1)"
                        $this.stone[$key+1] += $this.cache[$key]
                        break
                    }
                    { $_ -lt 10 } { $this.stone[$($_ * 2024)]+= $this.cache[$key]; break }
                    { $_ -ge 10 -and "$_".Length % 2 -eq 1 } { $this.stone[$($_ * 2024)]+= $this.cache[$key]; break }
                    { $_ -ge 10 -and "$_".Length % 2 -eq 0 } {

                        $split = "$_".Length / 2
                        $patt = "(\d{$split})"
                        [uint64]$s1, [uint64]$s2 = "$_" -split $patt | Where-Object { $_ }
                        $this.stone[$s1]+= $this.cache[$key]
                        $this.stone[$s2]+= $this.cache[$key]
                    }
                }
            }

        }
    }

    clear() {
        $this.cache.clear()
    }
    getresults() {
        
        $this.stone.keys | ForEach-Object {
            $this.result += $this.stone[$_]
        }
    }
}


$test = [stoneline]::new($data)

$test.blink(75)
$test.getresults()
$test.result


<#
$test2 = [stoneline]::new('125 17')
$test2.blink(25)
$test2.getresults()
$test2.result
#>