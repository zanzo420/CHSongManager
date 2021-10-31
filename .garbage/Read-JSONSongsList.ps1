####################################################
## VARIABLES #########################################
$JSON = $null
$FilePath = "G:\.CloneHero\Songs\songs.json"
####################################################

function TextBar($txt)
{
    write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host $txt -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host " ]|!" -ForegroundColor Red -BackgroundColor Black -NoNewline
}

function ReadSongsJSON()
{
    TextBar("Clone Hero Active Songs")
    $JSON = Get-Content -Raw -Path "$($FilePath)" | ConvertFrom-Json
    $JSON | Select-Object -Property Name,Artist,Album,Genre,Charter,Year,Playlist,lyrics,modchart,songlength,chartsAvailable | ForEach-Object {
        write-host ""
        TextBar("$($_.Artist)")
        write-host ""
        Write-Host "$($_.Artist) - $($_.Name) ($($_.Album)) ($($_.Year))"
        TextBar("Playlist: $($_.Playlist) || Genre: $($_.Genre) || Lyrics?: $($_.lyrics)")
        Write-host ""
    }
    write-host " $($JSON[0].Artist) - $($JSON[0].Name)" | Format-List -View *
    pause
    write-host "Total of " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "$($JSON.Count)" -ForegroundColor Green -BackgroundColor Black -NoNewline
    write-host " Active Songs" -ForegroundColor Red -BackgroundColor Black
}

ReadSongsJSON