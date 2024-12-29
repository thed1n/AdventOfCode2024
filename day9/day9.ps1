using namespace system.collections.generic
$data = Get-Content -Path .\day9\input.txt

[list[pscustomobject]]$disklayout = @()
[list[int]]$freespace = @()
$diskmap = $data -as [char[]]

$file = 0
$position = 0
for ($i=0;$i -lt $diskmap.count;$i++) {

    [int]$size = $diskmap[$i].ToString()

    
        if ($i % 2 -eq 0) {
            1..$size | % {
                $disklayout.add(
                    [PSCustomObject]@{
                        file = $file
                        type = 'file'
                    }
                )
                $position++
            }
            $file++
        } else {
            if ($size -eq 0) {continue}
            1..$size | % {
                $freespace.add($position)
                $disklayout.add([PSCustomObject]@{
                    file = $null
                    type = 'empty'
                })
                $position++
            }
            
        }
        
    }

#Init Defrag
$datablocks = $disklayout | ? type -eq 'file' | select -exp file
$zeroEndblocks = ($disklayout | ? type -eq 'empty').count
[array]::Reverse($datablocks)

for ($i=0;$i -lt $freespace.count;$i++) {
    $loc = $freespace[$i]
    $disklayout[$loc] = [pscustomobject]@{file = [int]$datablocks[$i]}
}
$disklayout.RemoveRange($datablocks.count,$zeroEndblocks)

[uint64]$sum = 0
for ($i=0;$i -lt $disklayout.count;$i++) {
$sum += $disklayout[$i].file * $i
}

$sum