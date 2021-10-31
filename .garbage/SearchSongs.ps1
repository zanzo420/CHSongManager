## VARIABLES ###############################
$SongsList = Get-Content "G:\.CloneHero\Songs\songs.txt"
$JSON = Get-Content -Raw -Path "G:\.CloneHero\Songs\songs.json" | ConvertFrom-Json
$SongsJson = Get-Content -Raw -Path "G:\.CloneHero\Songs\songs.json"
$songsfound,$input = ""
##########################################
## ALIASES #################################
Set-Alias -Name SS -Value SongSearch -Description "Search for a Song or Artist from your Clone Hero Songs List"
#Set-Alias -Name SJ -Value SearchJson -Description "Search for a Song or Artist from your Clone Hero Songs List"
##########################################

function CHSM()
{
    write-host "|[" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "CHSongManager" -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host "]|" -ForegroundColor Red -BackgroundColor Black -NoNewline
}

function SearchJson()
{
    $input = Read-Host "Enter the name of a Song or Artist to search for..."

    write-host "$(CHSM) Found the following search results for '" -NoNewline
    write-host "$($input)" -ForegroundColor Red -NoNewline #-BackgroundColor Black
    write-host "'..."
    
    $JSON | Select-Object -Property Name,Artist | ForEach-Object {
        if($_.Artist.Contains("$($input)") -eq $true)
        {
            write-host "$($_.Artist) - $($_.Name)"  | out-file "G:\.CloneHero\Songs\songsFound.txt" -Append
            write-host "$(CHSM) Search Found: " -NoNewline
            Write-Host "$($_.Artist) - $($_.Name) ($($_.Album)) ($($_.Year))" -ForegroundColor Green
        }
        
    }
    $JSON | Select-Object -Property Name,Artist | ForEach-Object{ if($_.Artist.ToString() -eq $($input)){write-host $_.Artist}}
    pause
    
    ForEach($SongJson in $SongsJson)
    {
        #if($_.Artist.Contains("$($input)") -eq $true -or $_.Name.Contains("$($input)") -eq $true)
        if($SongJson.Contains("$($input)") -eq $true)
        {
            $JSON | Select-Object -Property Name,Artist,Album,Genre,Charter,Year,Playlist,lyrics,modchart,songlength,chartsAvailable | ForEach-Object{
            #$save = "{`"Name`":`"$($_.Name)`",`"Artist`":`"$($_.Artist)`",`"Album`":`"$($_.Album)`",`"Genre`":`"$($_.Genre)`",`"Charter`":`"$($_.Charter)`",`"Year`":`"$($_.Year)`",`"Playlist`":`"$($_.Playlist)`",`"lyrics`":$($_.lyrics),`"modchart`":$($_.modchart),`"songlength`":$($_.songlength),`"chartsAvailable`":$($_.chartsAvailable)}," | out-host
            if($_.Artist.ToString().Contains($input) -eq $true)
            {
            write-host $_ | ConvertTo-Json | out-file "G:\.CloneHero\Songs\songsFound.txt" -Append
            write-host "$(CHSM) Search Found: " -NoNewline
            write-host "$($_.Artist) - $($_.Name)" -ForegroundColor Green
            write-host "[Playlist: " -ForegroundColor DarkGreen -NoNewline
            write-host "$($_.Playlist)" -ForegroundColor Green -NoNewline
            write-host "]" -ForegroundColor DarkGreen
            }
            }
        }
    }
    # Save search results to file...
    $songsfound = Get-Content "G:\.CloneHero\Songs\songsFound.txt"
    out-file "G:\.CloneHero\Songs\~SearchResults~\$($input).json" -InputObject $songsfound -Force
    #$songsfound | format-list | out-host
    write-host "Search found " -BackgroundColor Black -NoNewline
    write-host $songsfound.Count -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " results, out of " -BackgroundColor Black -NoNewline
    write-host $SongsList.Count -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " total songs." -BackgroundColor Black
    
    ## Reset Search #############
    $songsfound = ""
    out-file "G:\.CloneHero\Songs\songsFound.txt" -InputObject $songsfound -Force
    #########################
}

function SongSearch([string]$Find)
{
    if($Find -eq $null){$input = Read-Host "Enter the name of an artist or song name to search for..."}
    else{$input = $Find}

    write-host "$(CHSM) Found the following search results for '" -NoNewline
    write-host "$($input)" -ForegroundColor Red -NoNewline #-BackgroundColor Black
    write-host "'..."
    
    ForEach($song in $SongsList)
    {
        #write-host $song -ForegroundColor Cyan
        #out-file -InputObject $song "G:\.CloneHero\Songs\songscsv.txt" -Append
        if($song.Contains($input) -eq $true)
        {
            out-file "G:\.CloneHero\Songs\songsFound.txt" -InputObject $song -Append
            write-host "$(CHSM) Search Found: " -NoNewline
            write-host $song -ForegroundColor Green
        }
    }
    # Save search results to file...
    $songsfound = Get-Content "G:\.CloneHero\Songs\songsFound.txt"
    #set-string -InputString "$($songsfound[0].ToString())" -OldValue "" -NewValue "$($songsfound.Count)"
    $count = $songsfound.Count
    $songsfound[0] = "$($count)"
    $fixInput = Replace-SpecialChars -InputString $input
    out-file "G:\.CloneHero\Songs\~SearchResults~\$($fixInput).txt" -InputObject $songsfound -Force
    #$songsfound | format-list | out-host
    write-host "Search found " -BackgroundColor Black -NoNewline
    write-host $songsfound.Count -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " results, out of " -BackgroundColor Black -NoNewline
    write-host $SongsList.Count -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " total songs." -BackgroundColor Black
    
    ## Reset Search #############
    $songsfound = ""
    out-file "G:\.CloneHero\Songs\songsFound.txt" -InputObject $songsfound -Force
    #########################
}
#function SS(){SongSearch}
#function SJ(){SearchJson}

function Replace-SpecialChars {
    param($InputString)

    $SpecialChars = '[#?\/\{\[\(\)\]\}]'
    $Replacement  = '_A'

    $InputString -replace $SpecialChars,$Replacement
}