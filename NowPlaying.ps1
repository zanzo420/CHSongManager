$filePath = 'C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles'

$fileSong = "$($filePath)\currentsong.txt"
$fileSongs = "$($filePath)\songs.txt"
$fileJSON = "$($filePath)\songs.json"

$fileModded = "$($filePath)\nowplaying.txt"

function NowPlaying()
{
    $tmpFile = Get-Content $fileSong
    write-host $tmpFile -ForegroundColor Green
    if($($tmpFile.Length -gt 0) -or $($($tmpFile) -ne $null))
    {
        write-host "[CHSM] currentsong.txt has data! Copying original to nowplaying.txt..."
        Move-Item "$($filePath)\currentsong.txt" -Destination "$($filePath)\nowplaying.txt" -WhatIf
    }
}