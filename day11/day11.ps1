using namespace system.collections.generic
$data = Get-Content -Path .\day11\input.txt

class Stone {
    [uint64]$number
    
    Stone([uint64]$stoneid) {
        $this.number = $stoneid
    }

    blink($n) {
        
        $roundsLeft = 26 - $n
        switch ($this.number) {
            0 {
                if ([stoneline]::cache.ContainsKey($roundsLeft)) {
                    Write-Host "data found in cache round [$n] [$roundsleft] cache: [$([stoneline]::cache[$roundsLeft])]"
                    [stoneline]::sum.push([stoneline]::cache[$roundsLeft])
                    [stoneline]::remove.push($this)
                    break
                }
                else {
                    $this.number = 1; break
                }
            }
            { $this.number -lt 10 } { $this.number *= 2024; break }
            { $this.number -ge 10 -and "$($this.number)".Length % 2 -eq 1 } { $this.number *= 2024; break }
            { $this.number -ge 10 -and "$($this.number)".Length % 2 -eq 0 } {

                $split = "$($this.number)".Length / 2
                $patt = "(\d{$split})"
                [uint64]$s1, [uint64]$s2 = $this.number -split $patt | Where-Object { $_ }

                $this.number = $s1
                [stoneline]::stack.push([stone]::new($s2))
            }
        }
    }
    blink() {
        

        switch ($this.number) {
            0 { $this.number = 1; break }
            { $this.number -lt 10 } { $this.number *= 2024; break }
            { $this.number -ge 10 -and "$($this.number)".Length % 2 -eq 1 } { $this.number *= 2024; break }
            { $this.number -ge 10 -and "$($this.number)".Length % 2 -eq 0 } {

                $split = "$($this.number)".Length / 2
                $patt = "(\d{$split})"
                [uint64]$s1, [uint64]$s2 = $this.number -split $patt | Where-Object { $_ }

                $this.number = $s1
                [stoneline]::stack.push([stone]::new($s2))
            }
        }
    }
}
class StoneLine {
    static [list[stone]]$stones = @()
    static [stack[stone]]$stack = @{}
    static [hashtable]$cache = @{}
    static [stack[uint64]]$sum = @{}
    static [stack[stone]]$remove = @{}
    [uint64]$result = 0
    StoneLine ([string]$data) {
        $data -split ' ' | ForEach-Object {
            $this.newstone([uint64]$_)
        }
    }

    Add ([uint64]$stoneid) {
        $this.newstone($stoneid)
    }

    Add ([string]$data) {
        $data -split ' ' | ForEach-Object {
            $this.newstone([uint64]$_)
        }
    }

    NewStone ([uint64]$stoneid) {
        $s = [stone]::new($stoneid)        
        [stoneline]::stones.add($s)
    }
    
    Destack([int]$n) {
        while ([StoneLine]::remove.count -gt 0) {
            $removeStone = [stoneline]::remove.pop()
            [stoneline]::stones.Remove($removeStone)
        }
        while ([stoneline]::stack.Count -gt 0) {
            $tempStone = [stoneline]::stack.pop()
            #to adhere to the next round
            $roundsLeft = 25 - $n
            if ([stoneline]::cache.ContainsKey($roundsLeft)) {
                [stoneline]::sum.push([stoneline]::cache[$roundsLeft])
            }
            else { [stoneline]::stones.add($tempStone) }
        }
    }

    Destack() {
        while ([StoneLine]::remove.count -gt 0) {
            $removeStone = [stoneline]::remove.pop()
            [stoneline]::stones.Remove($removeStone)
        }
        while ([stoneline]::stack.Count -gt 0) {
            $tempStone = [stoneline]::stack.pop()
            [stoneline]::stones.add($tempStone)
        }
    }
    Blink ($n) {
        foreach ($stone in [StoneLine]::stones) {
            $stone.blink($n)
        }
    }
    Blink () {
        foreach ($stone in [StoneLine]::stones) {
            $stone.blink()
        }
    }
    clear() {
        [stoneline]::stones.clear()
        [stoneline]::stack.clear()
    }
    clearall() {
        [stoneline]::stones.clear()
        [stoneline]::stack.clear()
        [stoneline]::sum.clear()
        [stoneline]::cache.clear()
        [stoneline]::remove.clear()
    }
    getresults() {
        
        $this.result += [StoneLine]::stones.Count
        while ([stoneline]::sum.count -gt 0) {
            $n = [stoneline]::sum.pop()
            $this.result += $n
        }
    }
}

$test = [StoneLine]::new('0')
1..25 | ForEach-Object {
    [stoneline]::stones.blink()
    $test.Destack()
    [stoneline]::cache.add($_, [stoneline]::stones.Count)
}

$test.clear()

$test.add('7568 155731 0 972 1 6919238 80646 22')
1..25 | ForEach-Object {
    [stoneline]::stones.blink($_)
    $test.Destack()
    #[stoneline]::stones
    [stoneline]::stones.count
}
$test.getresults()
$test.result
