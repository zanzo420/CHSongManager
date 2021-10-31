$filePath = 'C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles'
$fileCurrentSong = "$($filePath)\currentsong.txt"
$fileModded = "$($filePath)\nowplaying.txt"
$Scrobbler = 'C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles\CHScrobbler.exe'
$playing = $false

function NowPlaying([string] $optText = "")
{
    # handle $optText if any
    if($optText -ne ""){ write-host "The changed file was: $($optText)" -ForegroundColor Red -BackgroundColor Black }
    write-host "Executing the 'NowPlaying' command on 'currentsong,txt' file..." -ForegroundColor Green -BackgroundColor Black

    # execution of NowPlaying...
    $tmpFile = Get-Content $fileCurrentSong
    write-host $tmpFile -ForegroundColor Green
    if($tmpFile.Length -gt 0){ $playing = $true }
    if( $($tmpFile -ne $null) -and $($playing -eq $true) )
    {
        #make a copy of the "currentsong.txt" and save it to "nowplaying.txt"...
        write-host "[CHSM] currentsong.txt has data! Copying original to nowplaying.txt..."
        Move-Item "$($filePath)\currentsong.txt" -Destination "$($filePath)\nowplaying.txt" -Force
        #load the current song data from "nowplaying.txt"
        $CurrentSong = Get-Content "$($filePath)\nowplaying.txt"
        $curSong = $CurrentSong[0] #Song
        $curArtist = $CurrentSong[1] #Artist
        $curAlbum = $CurrentSong[2] #Album
        $curYear = $CurrentSong[3] #Year
        $curGenre = $CurrentSong[4] #Genre
        $curPlaylist = $CurrentSong[5] #Playlist
        $curCharter = $CurrentSong[6] #Charter
        $outOneLine = "||[Song: $($CurrentSong[0]) || Artist: $($CurrentSong[1]) || Album: $($CurrentSong[2]) || Year: $($CurrentSong[3]) || Genre: $($CurrentSong[4]) || Playlist: $($CurrentSong[5]) || Charter: $($CurrentSong[6])]||"
        $outALL = "Song: $($CurrentSong[0])`nArtist: $($CurrentSong[1])`nAlbum: $($CurrentSong[2])`nYear: $($CurrentSong[3])`nGenre: $($CurrentSong[4])`nPlaylist: $($CurrentSong[5])`nCharter: $($CurrentSong[6])"
        $outNowPlaying = "$($curSong) by $($curArtist) (Charted by $($curCharter))"
        write-host "!|[ NOW PLAYING ]|!" -ForegroundColor Green -BackgroundColor Black
        write-host $($outNowPlaying)
        #pause
        #write-host $outOneLine -ForegroundColor Magenta -BackgroundColor Black
        #pause
        write-host $outALL -ForegroundColor Cyan -BackgroundColor Black

        $playing = $true
        #delete the nowplaying.txt file since it is no longer needed...
        #Remove-Item "$($filePath)\nowplaying.txt"
        $running = $true
    }
    else
    {
        if($playing -eq $true)
        {
            $playing = $false
            write-host "Song Completed!" -ForegroundColor Red -BackgroundColor Black
        }
        elseif($($playing -eq $false) -and $($running -eq $true))
        {
            write-host "Waiting for next song..."
        }
        else{return}
        
        if($running -eq $false)
        {
            write-host "Finished executing 'NowPlaying' command," #-ForegroundColor Green -BackgroundColor Black
        }
    }
    
    write-host "Waiting for next song..."
}

# Execute the function...
NowPlaying