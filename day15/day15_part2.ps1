using namespace system.collections.generic
$data = Get-Content -Path .\day15\input.txt

function draw {

    param(
        [bool]$draw
    )

    if ($draw) {
    for ($y=0;$y -lt $grid.count;$y++) {
        for ($x=0;$x -lt $grid[0].Length*2; $x++) {
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

$steps = $instructions -split '(?!\G\b.)(?!$)' | select -skip 1

$directions = @{
'>' = @(1,0)
'^' = @(0,-1)
'<' = @(-1,0)
'v' = @(0,1)
}
$box = @(']','[')
$maze = @{}
$node = [ordered]@{}
$startpos = ''
$stack = [stack[string]]::new()

for ($y=0;$y -lt $grid.count;$y++) {
    for ($x=0;$x -lt $grid.Length*2; $x++) {
        $tx = $x * 2
        if ($grid[$y][$x] -eq '@') {
            $startpos = "$tx,$y"
            $maze["$tx,$y"] = $grid[$y][$x]
            $maze["$($tx+1),$y"] = '.'
            continue
        }
        if ($grid[$y][$x] -eq 'O') {
            $maze["$tx,$y"] = '['
            $maze["$($tx+1),$y"] = ']'
            continue
        }
        $maze["$tx,$y"] = $grid[$y][$x]
        $maze["$($tx+1),$y"] = $grid[$y][$x]
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

        #East / West
    if ($maze["$xMove,$yMove"] -in $box -and "$($steps[$m])" -match '<|>' ) {


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

            for ($i=0;$i -lt $templist.count;$i++){
                if ($i -eq $templist.count-1) {
                    $maze[$($templist[0].pos)] = $templist[$i].symbol
                    #draw -draw $true
                    break
                }
                $maze[$($templist[$i+1].pos)] = $templist[$i].symbol
            }
            

        #set next start positions
        $xs,$ys = $templist[1].pos -split ',' -as [int[]]

        draw -draw $shouldDraw
        }
    }
    # North / south
    if ($maze["$xMove,$yMove"] -in $box -and "$($steps[$m])" -match '^|v' ) {
        $node = [ordered]@{}
        $node.add("$xs,$ys",[PSCustomObject]@{
            sym = '@'
            pos = "$xs,$ys"
            neigh = [list[string]]@(
                $maze["$xs,$($ys+$yn)"]
            )
            block = $false
            parent = ''
        })
        $stack.push("$xs,$($ys+$yn)")
        $move = $true
        while ($stack.count -gt 0) {
            $currentnode = $stack.pop()
            
            $xStack,$yStack = $currentnode -split ',' -as [int[]]
            $parent = "$xstack,$($ystack - $yn)"
            switch ($maze["$xStack,$yStack"]) {
                ']' {
                    if (-not $node.contains("$($xStack-1),$yStack;$xStack,$yStack")) {
                        $node.Add("$($xStack-1),$yStack;$xStack,$yStack",
                        [PSCustomObject]@{
                            sym = '[]'
                            pos = "$($xStack-1),$yStack;$xStack,$yStack"
                            neigh = [list[string]]@(
                                $maze["$($xStack-1),$($yStack+$yn)"]
                                $maze["$xStack,$($yStack+$yn)"]
                            )
                            block = $false
                            parent = $parent
                        })
                    }
                    if ($maze["$($xStack-1),$($yStack+$yn)"] -match '\]|\[') {
                        $stack.push("$($xStack-1),$($yStack+$yn)")
                    }
                    if ($maze["$xStack,$($yStack+$yn)"] -match '\]|\[') {
                        $stack.push("$xStack,$($yStack+$yn)")
                    }
                    if ($maze["$($xStack-1),$($yStack+$yn)"] -eq '#' -or $maze["$xStack,$($yStack+$yn)"] -eq '#') {
                        $move = $false
                    }
                }
                '[' {
                    if (-not $node.contains("$xStack,$yStack;$($xStack+1),$yStack")) {
                        $node.Add("$xStack,$yStack;$($xStack+1),$yStack",
                        [PSCustomObject]@{
                            sym = '[]'
                            pos = "$xStack,$yStack;$($xStack+1),$yStack"
                            neigh = [list[string]]@(
                                $maze["$xStack,$($yStack+$yn)"]
                                $maze["$($xStack+1),$($yStack+$yn)"]
                            )
                            block = $false
                            parent = $parent
                        })
                    }
                    if ($maze["$xStack,$($yStack+$yn)"] -match '\]|\[') {
                        $stack.push("$xStack,$($yStack+$yn)")
                    }
                    if ($maze["$($xStack+1),$($yStack+$yn)"] -match '\]|\[') {
                        $stack.push("$($xStack+1),$($yStack+$yn)")
                    }
                    if ($maze["$xStack,$($yStack+$yn)"] -eq '#' -or $maze["$($xStack+1),$($yStack+$yn)"] -eq '#') {
                        $move = $false
                    }
                }
                '#' {
                    $node[$parent].block = $true
                    $node.Add("$xStack,$yStack",
                    [PSCustomObject]@{
                        sym = '#'
                        pos = "$xStack,$yStack"
                        neigh = [list[string]]@(
                        )
                        block = $true
                        parent = $parent
                    })
                    $move = $false
                }
            }
        }

        if ($move) {
            [string[]]$keys = $node.Keys
            [array]::Reverse($keys)
            [hashset[string]]$beenmoved = @{}
            $keys | % {
                $key = $_
                if ($key -match ';') {
                    $a,$b = $key -split ';' 
                            #"_ $_"
                            $xM,$yM = $a -split ',' -as [int[]]
                            $xM2,$yM2 = $b -split ',' -as [int[]]
                            
                            $maze["$xM,$($yM+$yn)"] = '['
                            $maze["$xM2,$($yM2+$yn)"] = ']'
                            [void]$beenmoved.add("$xM,$($yM+$yn)")
                            [void]$beenmoved.add("$xM2,$($yM2+$yn)")
                                if (-not $beenmoved.contains("$xM,$yM")) {
                                    $maze["$xM,$yM"] = '.'
                                }
                                if (-not $beenmoved.contains("$xM2,$yM")) {
                                    $maze["$xM2,$yM"] = '.'
                                }
                }

                if ($node[$key].sym -eq '@') {
                    $xM,$yM = $key -split ',' -as [int[]]
                    $maze["$xM,$yM"] = '.'
                    $maze["$xM,$($yM+$yn)"] = '@'
                    $xs = $xM
                    $ys = $yM+$yn
                }
            }
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
    $stack.clear()
    
    $node.Clear()
    Write-Host "Next Move [$($m+1)] $($steps[$m+1])"
    #$m++
    #start-sleep -Milliseconds 500
}

#score
[uint64]$score = 0
$maze.keys | % {
    $key = $_
    if ($maze[$key] -eq '[') {
        $xScore,$yScore = $key -split ',' -as [int[]]
        $score += (100* $yscore) + $xscore
    }

}

[PSCustomObject]@{
    Part2 = $score
}


