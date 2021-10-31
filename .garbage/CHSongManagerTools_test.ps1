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
    ForEach($actPack in $activePks)
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
    
    $Folders = Get-ChildItem "$($PWD)" -Directory -Name -Recurse #| Select-Object -Property PSPath | Export-Csv "songs.csv"
    ForEach($Folder in $Folders)
    {
        Write-Host "Adding " -NoNewline
        write-host $Folder -ForegroundColor Green -NoNewline
        write-host " to CSV file..."
        $fTemp = $Folder
        #$fTmp = $Folder
        $fParent = $fTemp | Split-Path -Resolve -Parent
        $fFile = $fTemp | Split-Path -Resolve -Leaf
        $path2Song = $Folder | Select-Object -Property PSChildName, PSParentPath, PSPath
        $pathSong = "$($fParent)\$($fFile)"
        #$pathSong = "$($fFile)"
        #write-host "..\$($fParent)\$($fFile)" | out-file packsongs.txt -Append
        out-file -InputObject $pathSong -FilePath packsongs.txt -Append
        $path2Song | Export-Csv -Path "songs.csv" -Append -NoTypeInformation
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

function CombineJson()
{
    #### VARIABLES #################
    $dirFiles = 'G:\.CloneHero\c3db'
    ##############################

    # Ask the user for the prefix of the filenames...
    write-host "Enter the prefix of the filenames..."
    write-host "(Ex: c3db____.json, c3db is the prefix)" -BackgroundColor Black
    $input2 = read-host "Enter filename prefix."
    $filePrefix = $input2
    $combinedFile = "$($dirFiles)\$($filePrefix)_combined.json"
    # Load the partial JSON files into array variables...
    $js1 = Get-Content -Path "$($dirFiles)\c3db.json" -Raw | ConvertFrom-Json
    $js2 = Get-Content -Path "$($dirFiles)\c3db201-400.json" -Raw | ConvertFrom-Json
    $js3 = Get-Content -Path "$($dirFiles)\c3db401-600.json" -Raw | ConvertFrom-Json
    $js4 = Get-Content -Path "$($dirFiles)\c3db601-800.json" -Raw | ConvertFrom-Json
    $js5 = Get-Content -Path "$($dirFiles)\c3db801-1000.json" -Raw | ConvertFrom-Json
    $js6 = Get-Content -Path "$($dirFiles)\c3db1000-1059.json" -Raw | ConvertFrom-Json
    # Combine the partial JSON files, then convert back to JSON and output to a single JSON file.
    #@($js1) + @($js2) + @($js3) + @($js4) + @($js5) + @($js6) | ConvertTo-Json -Depth 5 | out-file -FilePath $combinedFile
    # or @($js1) + @($js2) | ConvertTo-Json -Depth 5 | Out-File -FilePath .\combined.json
    @($js1; $js2; $js3; $js4; $js5; $js6) | ConvertTo-Json -Depth 5 | Out-File -FilePath $combinedFile
}##END#############################CombineJson###

function Convert2Webm([string] $inFile)
{
    CHSM
    $tmpLen = $inFile.Length - 4
    $inFilename = $inFile.Substring($tmpLen)
    #ffmpeg -i video.avi -c:v libvpx -crf 10 -b:v 8M -c:a libvorbis video.webm
    ffmpeg -i $($inFile) -c:v libvpx -crf 10 -b:v 8M -c:a libvorbis $($inFilename).webm
}
function Convert2Webm([string] $inExt)
{
    #setup
    #$tmpLen = $inFile.Length - 4
    #$inFilename = $inFile.Substring($tmpLen)
    #ffmpeg -i video.avi -c:v libvpx -crf 10 -b:v 8M -c:a libvorbis video.webm
    ffmpeg -i "$($PWD)\video.$($inExt)" -c:v libvpx -crf 10 -b:v 8M -c:a libvorbis $($inFilename).webm
}

function ConvertBStoCH()
{
$dirBase = 'G:\.CloneHero\Songs\BeatSaber'
$dirOutput = 'G:\.CloneHero\Songs\BeatSaber\CloneHero Charts'
$Folders,$Files,$Name = $null
$count = 0
# Gets the Name and Count of all .zip files.
$Files = Get-ChildItem "$($dirBase)" -File -Name -Include *.zip -Recurse
$numFiles = $Files.Count
Write-Host '||[ ' -ForegroundColor DarkRed -NoNewline
Write-Host 'Songs Found: ' -ForegroundColor Red -NoNewline
Write-Host $numFiles -ForegroundColor Green -NoNewline # song count display
Write-Host ' ]||' -ForegroundColor DarkRed
Write-Host "---=============---=============---" -ForegroundColor DarkRed
Pause
foreach($File in $Files)
 {
     Write-Host "Converting: " -NoNewline
     Write-Host $File -ForegroundColor DarkGreen -NoNewline
     write-host " to Clone Hero..."
     #Run Spleeter on all .mp3 files found.
     #write-host "$($dirBase)\$($File)"
     BSChartConv "$($dirBase)\$($File)"
     Out-File -FilePath "SongsConverted.txt" -Append -InputObject $File
             
     $File = Split-Path -Path $File -Leaf
     Write-Host "Finished converting chart for " -ForegroundColor Red -NoNewline
     Write-Host "$File"
     #Out-File -FilePath "$dirOutput\\$Name_StemsRipped.txt" -Append -InputObject $File
 }
write-host "Successfully converted $($numFiles) Beat Saber chart(s) to Clone Hero!"
}###########################END##ConvertBStoCH###

function SongsDB()
{
    $tmpSongs = $SongsDIR
    $tmpSongs2 = $CHSongsDIR
    $exPath = "$($tmpSongs)\~ActiveSongs~"

    $getSongs = Get-ChildItem "$($tmpSongs)" -Directory -Name -Recurse
    ForEach($sng in $getSongs)
    {
        write-host $sng -ForegroundColor Green
        out-file "$($tmpSongs)\allsongs.txt" -InputObject $sng -Append
    }
    dPause('AFTER $getSongs, its Value is...')
    #write-host $getSongs
    write-host "##########################" -ForegroundColor Red -BackgroundColor Black
    write-host "GENERATING SONGS DATABASE FILE..." -ForegroundColor DarkRed -BackgroundColor Black
    write-host "##########################" -ForegroundColor Red -BackgroundColor Black
    pause
    $SongLists = Get-ChildItem $tmpSongs -File -Exclude $($exPath)* -Include *packsongs.txt -Recurse
    write-host $SongLists -ForegroundColor Magenta -BackgroundColor Black
    pause
    ForEach($songlist in $SongLists)
    {
        write-host "Reading $($songlist) songs list file..." -ForegroundColor Yellow
        pause
        $songlistSongs = Get-Content $songlist
        $sSplit = Split-String -InputString $songlistSongs -Separator "`n"
        write-host $sSplit[0] -ForegroundColor Cyan
        pause
        $sCount = 0
        ForEach($songlistSong in $songlistSongs)
        {
            write-host "[$($listName)]" -ForegroundColor DarkYellow -BackgroundColor Black -NoNewline
            write-host "$($sSplit[$sCount])" -ForegroundColor Yellow
            
            #write-host "[Song List: " -ForegroundColor Red -NoNewline
            #write-host "$($songlist)" -NoNewline
            #write-host "]" -ForegroundColor Red
            #write-host "Adding " -NoNewline
            #write-host "$($songlistSong)" -ForegroundColor Green -NoNewline
            #write-host " to SongsDB file..." -NoNewline
            write-host "`n$($sName)`n"
            Out-File -FilePath "$($SongsDIR)\songsdb.txt" -Append -InputObject $sSplit[$sCount]
            $sCount++
        }
        dPause('AFTER $songlistSongs LOOP')
        write-host "[SongsDB] " -ForegroundColor Red -NoNewline
        write-host "Adding $($songlist) to the SongsDB lists file..."
        Out-File -FilePath "$($SongsDIR)\songsdblists.txt" -Append -InputObject $songlist
    }
    write-host "#############################" -ForegroundColor Green -BackgroundColor Black
    write-host "FINISHED GENERATING SONGS DATABASE" -ForegroundColor DarkGreen -BackgroundColor Black
    write-host "#############################" -ForegroundColor Green -BackgroundColor Black
    pause
}

function SongExists()
{
    $tmpSongs = $SongsDIR
    $tmpSongs2 = $CHSongsDIR

    $getSongs = Get-ChildItem "$($tmpSongs)" -Directory -Name -Recurse
    #$getCHSongs = Get-ChildItem "$($tmpSongs2)" -Directory -Name -Recurse

    
    
    $Folders = Get-ChildItem "$($PWD)" -Directory -Name #| Select-Object -Property PSPath | Export-Csv "songs.csv"
    ForEach($Folder in $Folders)
    {
        Write-Host "Adding " -NoNewline
        write-host $Folder -ForegroundColor Green -NoNewline
        write-host " to CSV file..."
        $fTemp = $Folder
        #$fTmp = $Folder
        $fParent = $fTemp | Split-Path -Resolve -Parent
        $fFile = $fTemp | Split-Path -Resolve -Leaf
        $path2Song = $Folder | Select-Object -Property PSChildName, PSParentPath, PSPath
        $pathSong = "$($fParent)\$($fFile)"
        #write-host "..\$($fParent)\$($fFile)" | out-file packsongs.txt -Append
        out-file -InputObject $pathSong -FilePath packsongs.txt -Append
        $path2Song | Export-Csv -Path "songs.csv" -Append -NoTypeInformation
    }
}


#####################################
### UI FUNCTIONS ########################
function ShowBanner()
{
    write-host ""
    #write-host "  _______________" -ForegroundColor Red
    write-host '||[ ' -ForegroundColor Red -NoNewline -BackgroundColor Black
    write-host 'CH Song Manager' -ForegroundColor DarkRed -NoNewline -BackgroundColor Black
    write-host ' ]||' -ForegroundColor Red -BackgroundColor Black
    #write-host "  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" -ForegroundColor Red
    write-host "          " -NoNewline
    write-host 'by ȤāŋƶØ' -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host "         " -ForegroundColor DarkRed
}##END#######################UI#ShowBanner###

function CHSM()
{
    write-host "|[" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "CHSongManager" -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host "]|" -ForegroundColor Red -BackgroundColor Black -NoNewline
}
function chsm()
{
    write-host "||[" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "CHSM" -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host "]|" -ForegroundColor Red -BackgroundColor Black -NoNewline
}
function CHSMLog([string] $txt)
{
    write-host "[" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "CHSM" -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host "]" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host " $($txt)"
}

function PrintSong($artist, $name, $album)
{
    write-host "$($artist) " -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host " - " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "$($name) " -BackgroundColor Black -NoNewline
    write-host "(" -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host "$($album)" -BackgroundColor Black -NoNewline
    write-host ")" -ForegroundColor Red -BackgroundColor Black -NoNewline
}##END#########################UI#PrintSong###

function uiTextNote($txt)
{
    write-host "*** NOTE: " -NoNewline -ForegroundColor Cyan #-BackgroundColor Black
    write-host $($txt) -NoNewline -ForegroundColor DarkCyan
    write-host " ***" -NoNewline -ForegroundColor Cyan #-BackgroundColor Black
}##END########################UI#uiTextNote###

function uiTextExt([string] $txt, [string] $type = "LOG")
{
    write-host "$(chsm)[" -NoNewline -ForegroundColor Red -BackgroundColor Black
    write-host "$($type)" -NoNewline -ForegroundColor DarkCyan -BackgroundColor Black
    write-host "]||" -NoNewline -ForegroundColor Red -BackgroundColor Black
    write-host " $($txt)" -NoNewline -ForegroundColor Cyan
}##END########################UI#uiTextExt###

function uiTextBlock([string]$txt,[int]$style)
{
    if($style -eq 1)
    { # Red/Default
        write-host "!|[ " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    }elseif($style -eq 2)
    { # Red/DarkRed
        write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Red -BackgroundColor Black -NoNewline
    }elseif($style -eq 3)
    { # Green/Default
        write-host "!|[ " -ForegroundColor Green -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Green -BackgroundColor Black -NoNewline
    }elseif($style -eq 4)
    { # Green/DarkGreen
        write-host "!|[ " -ForegroundColor Green -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkGreen -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Green -BackgroundColor Black -NoNewline
    }elseif($style -eq 5)
    { # Blue/Default
        write-host "!|[ " -ForegroundColor Blue -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Blue -BackgroundColor Black -NoNewline
    }elseif($style -eq 6)
    { # Blue/DarkBlue
        write-host "!|[ " -ForegroundColor Blue -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkBlue -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Blue -BackgroundColor Black -NoNewline
    }elseif($style -eq 7)
    { # Yellow/Default
        write-host "!|[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Yellow -BackgroundColor Black -NoNewline
    }elseif($style -eq 8)
    { # Yellow/DarkYellow
        write-host "!|[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkYellow -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Yellow -BackgroundColor Black -NoNewline
    }elseif($style -eq 9)
    { # Magenta/Default
        write-host "!|[ " -ForegroundColor Magenta -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Magenta -BackgroundColor Black -NoNewline
    }elseif($style -eq 10)
    { # Cyan/DarkMagenta
        write-host "!|[ " -ForegroundColor Magenta -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkMagenta -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Magenta -BackgroundColor Black -NoNewline
    }elseif($style -eq 11)
    { # Cyan/Default
        write-host "!|[ " -ForegroundColor Cyan -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Cyan -BackgroundColor Black -NoNewline
    }elseif($style -eq 12)
    { # Cyan/DarkCyan
        write-host "!|[ " -ForegroundColor Cyan -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkCyan -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Cyan -BackgroundColor Black -NoNewline
    }elseif($style -eq 13)
    { # Gray/Default
        write-host "!|[ " -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Gray -BackgroundColor Black -NoNewline
    }elseif($style -eq 14)
    { # Gray/DarkGray
        write-host "!|[ " -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkGray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Gray -BackgroundColor Black -NoNewline
    }elseif($style -eq 15)
    { # White/Default
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline
    }elseif($style -eq 16)
    { # White/Gray
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline
    }elseif($style -eq 0)
    {# Black/White
        write-host "!|[ " -ForegroundColor Black -BackgroundColor White -NoNewline
        write-host $($txt) -ForegroundColor Black -BackgroundColor White -NoNewline
        write-host " ]|!" -ForegroundColor Black -BackgroundColor White -NoNewline
    }
    else #DEFAULT
    { # Red/Default
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline  
    }
}##END########################UI#TextBarRed###
function uiTextBar_Red($txt)
{
    write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
    write-host $($txt) -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
    write-host " ]|!" -ForegroundColor Red -BackgroundColor Black -NoNewline
}##END########################UI#TextBarRed###
function uiTextBar_Alert($txt)
{
    write-host "!|[ " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
    write-host $($txt) -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    write-host " ]|!" -NoNewline -ForegroundColor Yellow -BackgroundColor Black
}##END########################UI#uiTextNote_Error###
function uiTextBar([string]$txt,[string]$type) #red
{
    if($($type -eq "Alert") -or $($type -eq "alert") -or $($type -eq "a") -or $($type -eq "A") -or $($type -eq "1"))
    {
        write-host "!|[ ALERT: " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Yellow -BackgroundColor Black   
    }elseif($($type -eq "Error") -or $($type -eq "error") -or $($type -eq "E") -or $($type -eq "e") -or $($type -eq "2"))
    {
        write-host "!|[ ERROR: " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    }elseif($($type -eq "Info") -or $($type -eq "info") -or $($type -eq "I") -or $($type -eq "i") -or $($type -eq "3"))
    {
        write-host "!|[ INFO: " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkCyan -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    }elseif($($type -eq "Note") -or $($type -eq "note") -or $($type -eq "N") -or $($type -eq "n") -or $($type -eq "0"))
    {
        write-host "!|[ NOTE: " -NoNewline -ForegroundColor Gray -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkGray -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Gray -BackgroundColor Black
    }elseif($($type -eq "Red") -or $($type -eq "red") -or $($type -eq "R") -or $($type -eq "r") -or $($type -eq "4"))
    {
        write-host "!|[ " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    }
    else
    {
        write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
        write-host "$($type): " -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host $($txt) -NoNewline -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    }
}##END########################UI#uiTextError###

function uiDisplaySong([string]$sngArtist,[string]$sngName,[string]$sngAlbum,[int]$sngYear)
{
    write-host "" -ForegroundColor Red -BackgroundColor Black -NoNewline
}

function uiJsonSong([string]$sngName,[string]$sngArtist,[string]$sngAlbum,[string]$sngGenre,[string]$sngCharter,[string]$sngYear,[string]$sngPlaylist,[bool]$sngLyrics,[bool]$sngMod,[int]$sngLength,[int]$sngCA)
{
    
}
function CHSM_Menu()
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
        5{ConvertBStoCH}
    }
}##END###########################UI#Menu###

function dPause([string]$txt)
{
    write-host "`n!|[ $($txt) ]|!" -ForegroundColor Yellow -BackgroundColor Black
    pause
}

################################################
## NowPlaying FUNCTION ##############################
<#function NowPlaying([string] $optText = "")
{
    ##VARIABLES######################
    $curPath = 'C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles'
    $curCurrentSong = "$($curPath)\currentsong.txt"
    $curModded = "$($curPath)\nowplaying.txt"
    ################################

    # handle $optText if any
    if($optText -ne ""){ write-host "The changed file was: $($optText)" -ForegroundColor Red -BackgroundColor Black }
    write-host "Executing the 'NowPlaying' command on 'currentsong,txt' file..." -ForegroundColor Green -BackgroundColor Black

    # execution of NowPlaying...
    $curTempFile = Get-Content $curCurrentSong
    write-host $curTempFile -ForegroundColor Green
    if($($curTempFile.Length -gt 0) -or $($($curTempFile) -ne $null))
    {
        #make a copy of the "currentsong.txt" and save it to "nowplaying.txt"...
        write-host "[CHSM] currentsong.txt has data! Copying original to nowplaying.txt..."
        Copy-Item "$($curPath)\currentsong.txt" -Destination "$($curPath)\nowplaying.txt" -Force
        #load the current song data from "nowplaying.txt"
        $CurrentSong = Get-Content "$($curPath)\nowplaying.txt"
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
        write-host $outOneLine -ForegroundColor Magenta -BackgroundColor Black
        #pause
        write-host $outALL -ForegroundColor Cyan -BackgroundColor Black

        #delete the nowplaying.txt file since it is no longer needed...
        Remove-Item "$($curPath)\nowplaying.txt"
    }else #if($curTempFile -eq "")
    {
        write-host "The 'currentsong.txt' file is empty." -ForegroundColor Red -BackgroundColor Black
        return
    }
    write-host "Finished executing 'NowPlaying' command," #-ForegroundColor Green -BackgroundColor Black
    Wait-FileChange -File $waitFile -Action $waitAction
}##END###############################NowPlaying####
################################################
#>

################################################
## Wait-FileChange FUNCTION ###########################
$waitFile = "C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles\currentsong.txt" # The file to watch
$waitAction = { write-host "$(D:\.repos\.CloneHero\CHSongManager\NowPlaying.ps1)"}
$global:FileChanged = $false
function Wait-FileChange {
    param( [string]$File, [string]$Action ) 

    ## VARIABLES ####################
    $waitFile = "C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles\currentsong.txt" # The file to watch
    #$waitAction = {.\D:\.repos\.CloneHero\CHSongManager\NowPlaying.ps1 }
    #$global:FileChanged = $false

    $FilePath = Split-Path $File -Parent
    $FileName = Split-Path $File -Leaf
    $ScriptBlock = [scriptblock]::Create($Action)
    ###############################
    $updated = { Write-Host "File: " $EventArgs.FullPath " " $EventArgs.ChangeType ;$global:UpdateEvent = $EventArgs}

    # Create watcher to watch the file for changes...
    $Watcher = New-Object IO.FileSystemWatcher 
    $Watcher.Path = $FilePath
    $Watcher.Filter = $FileName
    $Watcher.IncludeSubdirectories = $false
    $Watcher.NotifyFilter = [System.IO.NotifyFilters]::LastAccess, [System.IO.NotifyFilters]::LastWrite, [System.IO.NotifyFilters]::FileName, [System.IO.NotifyFilters]::DirectoryName
    
    if($ChangedEvent) {$ChangedEvent.Dispose()}
    $ChangedEvent = Register-ObjectEvent $Watcher "Changed" -Action $waitAction
    
    $Watcher.EnableRaisingEvents = $true
    $onChange = Register-ObjectEvent $Watcher Changed -Action {$global:FileChanged = $true}

    # Sleep while file is unchanged...
    while ($global:FileChanged -eq $false) {Start-Sleep -Milliseconds 100}

    #& $ScriptBlock 
    #Unregister-Event -SubscriptionId $onChange.Id
    #if($ChangedEvent) {$ChangedEvent.Dispose()}
    $global:FileChanged = $false
}##END##############################Wait-FileChange ####
$global:FileChanged = $false
function Wait4Song(){ Wait-FileChange -File $waitFile -Action $waitAction }
###################################################
#Wait-FileChange -File $waitFile -Action $waitAction