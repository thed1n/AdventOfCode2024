using namespace system.collections.generic
$data = Get-Content -Path .\day15\input.txt

function draw {

    param(
        [bool]$draw
    )

    if ($draw) {
    for ($y=0;$y -lt $grid.count;$y++) {
        for ($x=0;$x -lt $grid.Length; $x++) {
            if ($maze["$x,$y"] -eq '@') {
                write-host $maze["$x,$y"] -NoNewline -ForegroundColor Red
                continue
            }
            write-host $maze["$x,$y"] -NoNewline
        }
        write-host
    }
}
}
$grid = ''
$instructions = ''
$isGrid = $true
$data | % {

    if ([string]::IsNullOrWhiteSpace($_)) {
        write-host "Is null or empty"
        $isGrid = $false
        return
    }
    if ($isGrid) {
        $grid += "$_`n"
        return
    }
    $instructions += $_
}
$grid = $grid.Remove($grid.Length-1,1)
$grid = $grid -split '\r?\n'
'>^<v' -split '(?!\G\b.)(?!$)' | ? {$_}
$steps = $instructions -split '(?!\G\b.)(?!$)' | select -skip 1

$directions = @{
'>' = @(1,0)
'^' = @(0,-1)
'<' = @(-1,0)
'v' = @(0,1)
}

$maze = @{}
$startpos = ''
for ($y=0;$y -lt $grid.count;$y++) {
    for ($x=0;$x -lt $grid.Length; $x++) {
        if ($grid[$y][$x] -eq '@') {
            $startpos = "$x,$y"
        }
        $maze["$x,$y"] = $grid[$y][$x]
    }
}

$shouldDraw = $false
$xs,$ys = $startpos -split ',' -as [int[]]
[list[pscustomobject]]$templist = @()
for ($m = 0; $m -lt $steps.count;$m++) {

    $xn,$yn = $directions["$($steps[$m])"]

    $xMove = $xs + $xn
    $yMove = $ys + $yn
    $templist.Add(
        [pscustomobject]@{
            Symbol = '@'
            pos = "$xs,$ys"
        })

    if ($maze["$xMove,$yMove"] -eq 'O') {
        $templist.Add(
            [pscustomobject]@{
                Symbol = $maze["$xMove,$yMove"]
                pos = "$xMove,$yMove"
            }
        )
        #push
        $xNext = $xMove + $xn
        $yNext = $yMove + $yn
        $change = $false
        DO {

            if ($maze["$xNext,$yNext"] -eq '#') {
                break
            }
            if ($maze["$xNext,$yNext"] -eq '.') {
                $templist.Add(
                    [pscustomobject]@{
                        Symbol = $maze["$xNext,$yNext"]
                        pos = "$xNext,$yNext"
                    }
                )
                $change = $true
            break
            }
            $templist.Add(
                    [pscustomobject]@{
                        Symbol = $maze["$xNext,$yNext"]
                        pos = "$xNext,$yNext"
                    }
            )

            $xNext += $xn
            $yNext += $yn

        } while ($true)

        #Swap and insert
        if ($change) {
        $first = $templist[0].pos
        $temp1 = $templist[1].pos
        $temp2 = $templist[-1].pos

        $maze[$first] = '.'
        $maze[$temp1] = '@'
        $maze[$temp2] = 'O'

        #set next start positions
        $xs,$ys = $temp1 -split ',' -as [int[]]

        draw -draw $shouldDraw
        }
    }
    if ($maze["$xMove,$yMove"] -eq '.') {
        $maze["$xs,$ys"] = '.'
        $maze["$xMove,$yMove"] ='@'
        $xs = $xMove
        $ys = $yMove
        draw -draw $shouldDraw
    }
    $templist.clear()
    Write-Host "Next Move [$($m+1)] $($steps[$m+1])"
    #start-sleep -seconds 1
}

#score
[uint64]$score = 0
$maze.keys | % {
    $key = $_
    if ($maze[$key] -eq 'O') {
        $xScore,$yScore = $key -split ',' -as [int[]]
        $score += (100* $yscore) + $xscore
    }

}

[PSCustomObject]@{
    Part1 = $score
}