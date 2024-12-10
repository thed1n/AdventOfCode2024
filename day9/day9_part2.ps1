using namespace system.collections.generic
$data = Get-Content -Path .\day9\input.txt

[list[pscustomobject]]$disklayout = @()
[list[int]]$freespace = @()
[stack[pscustomobject]]$filechunks = @()
[list[pscustomobject]]$continuesfreespace = @()
$diskmap = $data -as [char[]]

$file = 0
$position = 0
for ($i = 0; $i -lt $diskmap.count; $i++) {

    [int]$size = $diskmap[$i].ToString()

    
    if ($i % 2 -eq 0) {
        $filechunks.push(
            [pscustomobject]@{
                File  = $file
                Start = $position
                End   = $position + $size - 1
                Size  = $size
            })   
        1..$size | ForEach-Object {
            $disklayout.add(
                [PSCustomObject]@{
                    file = $file
                    type = 'file'
                }
            )
            $position++
        }
        $file++
    }
    else {
        if ($size -eq 0) { continue }
        $continuesfreespace.add(
            [pscustomobject]@{
                Start = $position
                End   = $position + $size - 1
                Size  = $size
            }
        )
        1..$size | ForEach-Object {
            $freespace.add($position)
            $disklayout.add([PSCustomObject]@{
                    file = $null
                    type = 'empty'
                })
            $position++
        }
            
    }
        
}

#Init filechunkmover

:outer while ($filechunks.count -gt 0) {
    $currentFile = $filechunks.pop()
    for ($c = 0; $c -lt $continuesfreespace.count; $c++) {

        if ($currentFile.start -lt $continuesfreespace[$c].start) {
            continue
        }

        if ($continuesfreespace[$c].size -ge $currentFile.size) {

            $continuesfreespace[$c].Start..$($continuesfreespace[$c].Start + $currentFile.size - 1) | ForEach-Object {
                $disklayout[$_].file = $currentFile.File
                $disklayout[$_].type = 'file'
            }
            write-host "moved $($currentFile.File) from $($currentFile.Start),$($currentFile.End) to $($continuesfreespace[$c].Start),$($continuesfreespace[$c].Start + $currentFile.size - 1)"

            if ($continuesfreespace[$c].size - $currentFile.Size -gt 0) {
                $remainderSize = $continuesfreespace[$c].size - $currentFile.Size
                $continuesfreespace.Insert($c+1,
                    [pscustomobject]@{
                        Start = $continuesfreespace[$c].end - $remainderSize + 1
                        End   = $continuesfreespace[$c].end
                        Size  = $remainderSize
                    }
                )
            }

            $currentFile.start..$($currentFile.start+$currentFile.Size-1) | % {
                $disklayout[$_].file = $null
                $disklayout[$_].type = 'empty'
            }

            [void]$continuesfreespace.Remove($continuesfreespace[$c])
            continue outer
        }
        
    }
}

[uint64]$sum = 0
for ($i = 0; $i -lt $disklayout.count; $i++) {
    $sum += $disklayout[$i].file * $i
}

$sum