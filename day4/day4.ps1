using namespace system.collections.generic
$data = Get-Content -Path .\day4\input.txt



$grid = @{}

for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        $grid.add("$x,$y",$data[$y][$x])
    }
}



[hashset[string]]$foundxmas = @{}
$score = 0
for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        [list[string]]$tempcord = @()
        #find-xmas -x $x -y $y

        $xmas = ''
        $tempcord.clear()
        #up
        for ($up=$y;$up -lt $y-4;$up--) {
            if ($up -lt 0) {
                break
            }
            $xmas += $grid["$x,$up"]
            $tempcord.add("$x,$up")
        }
        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
            $tempcord.clear()
        }

        #down 
        $xmas = ''
        $tempcord.clear()
        for ($down=$y; $down -lt $y+4; $down++) {
            if ($down -gt $data.count) {
                break
            }
            $xmas  += $grid["$x,$down"]
            $tempcord.add("$x,$down")
        }
        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }
        #right
        $xmas = ''
        $tempcord.clear()
        for($right=$x;$right -lt $x+4;$right++) {
            if ($right -gt $data[0].length) {
                break
            }
            $xmas  += $grid["$right,$y"]
            $tempcord.add("$right,$y")
        }

        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }
        #left 
        $tempcord.clear()
        $xmas = ''
        for ($left=$x;$left -lt $x-4; $left--) {
            if ($left -lt 0) {
                break
            }
            $xmas  += $grid["$left,$y"]
            $tempcord.add("$left,$y")
        }
        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }

        #diagonal up/left
        $xmas = ''
        $tempcord.clear()
        for (($left=$x),($up=$y);$left -lt $x-4; $left--,$up--) {
            if ($left -lt 0 -or $up -lt 0) {
                break
            }
            $xmas  += $grid["$left,$up"]
            $tempcord.add("$left,$up")
        }
        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }
        

        #diagonal up/right
        $xmas = ''
        $tempcord.clear()
        for (($right=$x),($up=$y);$right -lt $x+4; $right++,$up--) {
            if ($right -gt $data[0].Length -or $up -lt 0) {
                break
            }
            $xmas  += $grid["$right,$up"]
            $tempcord.add("$right,$up")
        }

        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }
        

        #diagonal down/left
        $xmas = ''
        $tempcord.clear()
        for (($left=$x),($down=$y);$left -lt $x-4; $left--,$down++) {
            if ($left -lt 0 -or $down -gt $data.count) {
                break
            }
            $xmas  += $grid["$left,$down"]
            $tempcord.add("$left,$down")
        }
        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }
        
        
        #diagonal down/right
        $xmas = ''
        $tempcord.clear()
        for (($right=$x),($down=$y);$right -lt $x+4; $right++,$down++) {
            if ($right -gt $data[0].Length -or $down -gt $data.count) {
                break
            }
                #write-host "$right,$down"
                $xmas  += $grid["$right,$down"]
                $tempcord.add("$right,$down")
        }

        if ($xmas -eq 'XMAS' -or $xmas -eq 'SAMX') {
            $score++
            $tempcord | % {
                [void]$foundxmas.add($_)
            }
        }

}
}


#Render Grid
for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        if ($foundxmas.Contains("$x,$y")) {
            Write-host $grid["$x,$y"] -NoNewline -ForegroundColor Red
        }
        else {write-host $grid["$x,$y"] -NoNewline}
    }
    write-host
}
[pscustomobject]@{
    Part1 = $score
}