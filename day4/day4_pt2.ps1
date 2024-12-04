using namespace system.collections.generic
$data = Get-Content -Path .\day4\input.txt



$grid = @{}

for ($y = 0; $y -lt $data.count; $y++) {
    for ($x = 0; $x -lt $data[0].Length; $x++) {
        $grid.add("$x,$y", $data[$y][$x])
    }
}

[hashset[string]]$foundxmas = @{}
$score = 0
for ($y=0;$y -lt $data.count;$y++) {
    for ($x=0;$x -lt $data[0].Length;$x++) {
        [list[string]]$tempcord = @()
        #find-xmas -x $x -y $y
        $foundX = 0
        if ($grid["$x,$y"] -ne 'A') {
            continue
        }

        $xmas = ''

        #diagonal down/left
        $xmas = ''
        $tempcord.clear()
        for (($left = $x+1), ($down = $y-1); $down -lt $y + 2; $left--, $down++) {
            if ($left -lt 0 -or $down -gt $data.count) {
                break
            }
            #write-host "$left,$down $($grid["$left,$down"])"
            $xmas += $grid["$left,$down"]
            $tempcord.add("$left,$down")
        }
        if ($xmas -eq 'MAS' -or $xmas -eq 'SAM') {
            $foundX++
        }

        #diagonal down/right
        $xmas = ''
        #$tempcord.clear()
        for (($right = $x-1), ($down = $y-1);  $down -lt $y + 2; $right++, $down++) {
            if ($right -gt $data[0].Length -or $down -gt $data.count) {
                break
            }
            #write-host "$right,$down $($grid["$right,$down"])"
            $xmas += $grid["$right,$down"]
            $tempcord.add("$right,$down")
        }

        if ($xmas -eq 'MAS' -or $xmas -eq 'SAM') {
            $foundX++
        }

        if ($foundX -eq 2) {
            $score++
            $tempcord | ForEach-Object {
                [void]$foundxmas.add($_)
            }}

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
    Part2 = $score
}