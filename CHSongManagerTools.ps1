####################################
### VARIABLES ########################
$WorkingDir = "$($PWD)"
# Read settings from file...
$SettingsFile = Get-Content "$($PSScriptRoot)\settings.txt"
$SongsDIR = "$($SettingsFile[0])" #| out-host
$CHSongsDIR = "$($SettingsFile[1])" #| out-host
$activePacks = Get-Content "$($SettingsFile[2])" #| out-host
#####################################


#####################################
### FUNCTIONS #########################
function ActivateSongPack()
{
    $GHPacks = Get-Content "G:\.CloneHero\Songs\Guitar Hero\songpacks.txt" #Guitar Hero Song Packs
    $RBPacks = Get-Content "G:\.CloneHero\Songs\Rock Band\songpacks.txt" #Rock Band Song Packs

    write-host "Enter the name of a game from the choices below..."
    write-host "[GAMES]" -BackgroundColor Black -ForegroundColor Red -NoNewline
    write-host " Band Hero, Guitar Hero, Rock Band, Full Albums, or Custom Charted..." -BackgroundColor Black
    $gName = Read-Host "Enter a Game Name..."

    write-host "Enter the name of a $($gName) Song Pack name from the list of Song Packs for that game from below..."
    write-host "[GUITAR HERO]" -BackgroundColor Black -ForegroundColor Red #-NoNewline
    write-host "$(ForEach($GHPack in $GHPacks){write-host "$($GHPack)" -ForegroundColor DarkGreen -BackgroundColor Black}) ----END GUITAR HERO----" -ForegroundColor Green -BackgroundColor Black
    #write-host "Guitar Hero 5, On Tour, On Tour Decades, On Tour - Modern Hits, World Tour, Warriors of Rock, WoR DLC, Smash Hits, Van Halen" -BackgroundColor Black
    #write-host "NOTE: Enter Guitar Hero + the pack name from the list above.)`n"
    write-host "[ROCK BAND] " -BackgroundColor Black -ForegroundColor Red
    write-host "$(ForEach($RBPack in $RBPacks){write-host "$($RBPack)" -ForegroundColor DarkGreen -BackgroundColor Black}) ----END ROCK BAND----" -ForegroundColor Green -BackgroundColor Black
    #write-host "$($RBPacks | Format-String -Format "{0}:{1}, {2}, {3}`n" -Count 4)`n" -BackgroundColor Black
    #write-host "Rock Band 1, Rock Band 2, Rock Band 3, Rock Band 4, RB1 DLC, RB2 DLC, `nRB3 DLC, RB4 DLC, Green Day Rock Band. The Beatles Rock Band, Lego Rock Band, Rock Band ACDC" -BackgroundColor Black
    write-host "[BAND HERO] " -BackgroundColor Black -ForegroundColor Red -NoNewline
    write-host "Band Hero" -BackgroundColor Black
    $name = Read-Host "Enter a $($gName) Song Pack name..."
    
    $activePack = "$($gName)\$($name)" 
    $activePack | out-file -FilePath "$($CHSongsDIR)\activepacks.txt" -Append
    
    $pkSongs = Get-Content -Path "$($SongsDir)\$($gName)\$($name)\packsongs.txt"
    write-host "[Package Found!] " -ForegroundColor Green -BackgroundColor Black -NoNewline
    write-host "$($name)" -BackgroundColor Black
    
    write-host "Moving " -NoNewline
    write-host "$($pkSongs.Count)" -ForegroundColor Green -NoNewline
    write-host " songs from the " -NoNewline
    write-host $($gName)\$($name) -ForegroundColor Red -NoNewline
    write-host " Song Pack into Clone Hero Songs directory..."
    ForEach($pkSong in $pkSongs)
    {
        $actSongName = $pkSong | Split-Path -Leaf
        $actSongPath = $pkSong | Split-Path -Parent
        #mkdir -Path "$($CHSongsDIR)\$($gName)\$($name)"
        write-host "Processing... $($actSongName)`n$($pkSong)"
        Move-Item -Path "$pkSong" -Destination "$($CHSongsDIR)\$($gName)\$($name)" -Force
        #$pkSong | out-file -FilePath "$($CHSongsDIR)\activepacks.txt" -Append
        $add2act = "$($CHSongsDIR)\$($gName)\$($name)\$($actSongName)" | out-file -FilePath "$($CHSongsDIR)\$($gName)\$($name)\activesongs.txt" -Append
        $pkSong | out-file -FilePath "$($CHSongsDIR)\$($gName)\$($name)\originalpaths.txt" -Append
    }
}##END##########ActivateSongPack##

function RemoveAllSongPacks()
{
    $activePks = Get-Content "$($CHSongsDIR)\activepacks.txt"
    $actPackList = $activePks
    $actPackList | format-list | Out-Host
    write-host "$actPackList" -BackgroundColor Black -ForegroundColor Magenta
    write-host "$($CHSongsDIR)\activepacks.txt" -BackgroundColor Black -ForegroundColor Yellow
    ForEach($actPack in $activePacks)
    {
       $packSongs = Get-Content "$($CHSongsDIR)\$($actPack)\activesongs.txt"
       $packSongs | format-list | out-host
       #$origPath = Get-Content "$($CHSongsDIR)\$($actPack)\originalpaths.txt"
       #$origPath | format-list | out-host
       #cd $SongsDIR
       $pkName = $actPack
       $pkName.Substring(2) | Split-Path -Leaf | out-host
       $sngPath = $packSongs
       $sngName = $packSongs
       $sngPath = $sngPath | Split-Path -Parent
       $sngName = $sngName | Split-Path -Leaf
       ForEach($actSong in $packSongs)
       {
        $getpath = $actSong.Substring(2)
        $getname = $actSong
        $getfull = "$($SongsDIR)\$($getpath)"
        $getpath  = $getpath | split-path -Parent
        $getname = $getname | split-path -Leaf

        #write-host "MOVED: " -BackgroundColor Black
        #write-host $actSong.Substring(15) -BackgroundColor Black
        #write-host "FROM:" -ForegroundColor Green -BackgroundColor Black
        #write-host $getfull -BackgroundColor Black -ForegroundColor Green
        #write-host "TO:" -ForegroundColor Red -BackgroundColor Black
        #write-host "$($SongsDIR)\$($pkName)\$($getname)" -BackgroundColor Black -ForegroundColor Red
        Move-Item -Path "$($actSong)" -Destination "$($SongsDIR)\$($pkName)\$($getname)" -Force -WhatIf
       }
       
       Remove-Item -Path "$($CHSongsDIR)\$($pkName)\activesongs.txt" -WhatIf
       Remove-Item -Path "$($CHSongsDIR)\$($pkName)\originalpaths.txt" -WhatIf
    }
    write-host "$($CHSongsDIR)\activepacks.txt" -BackgroundColor Black -ForegroundColor Yellow
    Clear-Content -Path "$($CHSongsDIR)\activepacks.txt" -WhatIf
    
}##END##########RemoveAllSongPacks##

function Get-PackSongsList()
{
    $WorkingDir = "$($PWD)"
    ShowBanner
    Write-Host "Current Working Directory: " -ForegroundColor Green -NoNewline #-BackgroundColor Black
    write-host $WorkingDir #-BackgroundColor Black
    pause
    
    $Folders = Get-ChildItem "$($PWD)" -Directory -Name #| Select-Object -Property PSPath | Export-Csv "songs.csv"
    ForEach($Folder in $Folders)
    {
        Write-Host "Adding $($Folder) to CSV file..."
        $fTemp = $Folder
        #$fTmp = $Folder
        $fParent = $fTemp | Split-Path -Resolve -Parent
        $fFile = $fTemp | Split-Path -Resolve -Leaf
        $path2Song = $Folder | Select-Object -Property PSChildName, PSParentPath, PSPath
        $pathSong = "$($fParent)\$($fFile)"
        #write-host "..\$($fParent)\$($fFile)" | out-file packsongs.txt -Append
        out-file -InputObject $pathSong -FilePath packsongs.txt -Append
        Export-Csv -InputObject "$($path2Song.ToString())" - -Path "songs.csv" -Append -NoTypeInformation
    }
    #get total number of songs in the pack...
    $numSongs = ls -directory -name
    $nCount = $numSongs.Count
    $numSongs.Count | out-file "count.txt"
    $dirName = Split-Path $WorkingDir -Leaf
    write-host "|[$($dirName)]|" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " Song List Generation Complete..."
    write-host "# of Songs: " -BackgroundColor Black -NoNewline
    write-host "$($nCount)" -ForegroundColor Green -BackgroundColor Black
    cd ..
    pause

}##END##########Get-PackSongsList##

function Get-SongPacksList()
{
    ShowBanner
    Write-Host "Current Working Directory: " -ForegroundColor Green -NoNewline #-BackgroundColor Black
    write-host $WorkingDir #-BackgroundColor Black
    pause

    $Folders = Get-ChildItem "$WorkingDir" -Directory -Name #| Select-Object -Property PSPath | Export-Csv "songs.csv"
    ForEach($Folder in $Folders)
    {
        Write-Host "Adding $($Folder) to CSV file..."
        $fTemp = $Folder
        #$fTmp = $Folder
        $fParent = $fTemp | Split-Path -Resolve -Parent
        $fFile = $fTemp | Split-Path -Resolve -Leaf
        $path2Song = $Folder | Select-Object -Property PSChildName, PSParentPath, PSPath
        $pathSong = "$($fFile)"
        #write-host "..\$($fParent)\$($fFile)" | out-file packsongs.txt -Append
        out-file -InputObject $pathSong -FilePath songpacks.txt -Append
        Export-Csv -InputObject $path2Song -Path ".\packs.csv" -Append -NoTypeInformation
    }
    #get total number of songs in the pack...
    $numSongs = ls -directory -name
    $numSongs.Count | out-file "count.txt"
    $dirName = Split-Path $WorkingDir -Leaf
    write-host "|[$($dirName)]|" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " Song List Generation Complete..."
    write-host "# of Songs: " -BackgroundColor Black -NoNewline
    write-host $numSongs.Count -ForegroundColor Green -BackgroundColor Black
    cd ..
    pause
}##END##########Get-SongPacksList##


#####################################
### UI FUNCTIONS ########################
function ShowBanner()
{
    write-host ""
    write-host '||[ ' -ForegroundColor Red -NoNewline #-BackgroundColor Black
    write-host 'CH Song Manager' -ForegroundColor DarkRed -NoNewline #-BackgroundColor Black
    write-host ' ]||' -ForegroundColor Red #-BackgroundColor Black
    write-host "          by Zanzo          `n" -ForegroundColor DarkRed #-BackgroundColor Black
}##END#######################UI#ShowBanner###
function PrintSong($artist, $name, $album)
{
    write-host "$($artist) " -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host " - " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "$($name) " -BackgroundColor Black -NoNewline
    write-host "(" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "$($album)" -BackgroundColor Black -NoNewline
    write-host ")" -ForegroundColor Red -BackgroundColor Black -NoNewline
}##END#########################UI#PrintSong###
function TextBar($txt)
{
    write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host $txt -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host " ]|!" -ForegroundColor Red -BackgroundColor Black -NoNewline
}##END##########################UI#TextBar###
function Menu()
{
    write-host "[1] Activate Song Pack`n[2] Remove ALL Song Packs`n[3] Generate a Songs List for a Pack`n[4] Generate a Packs List" -ForegroundColor Green -BackgroundColor Black
    write-host "NOTE: You must run options [2] or [3] from the Packs folder." -ForegroundColor DarkGreen -BackgroundColor Black
    $choice = read-host "What would you like to do?"

    switch($choice)
    {
        1{ActivateSongPack}
        2{RemoveAllSongPacks}
        3{Get-PackSongsList}
        4{Get-SongPacksList}
    }
}##END###########################UI#Menu###
