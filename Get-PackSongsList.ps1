function Get-PackSongsList()
{
    ShowBanner
    Write-Host "Current Working Directory: " -ForegroundColor Green -NoNewline #-BackgroundColor Black
    write-host $PSScriptRoot #-BackgroundColor Black
    pause
    
    ####################################
    ### VARIABLES ########################
    #$WorkingDIR = 'G:\.CloneHero\Songs\~ActiveSongs~'
    $WorkingDir = ',\'
    $SongsDIR = 'G:\.CloneHero\Songs'
    $CHSongsDIR = "$($env:APPDATA)\Clone Hero Launcher\gameFiles\Songs"
    $SettingsFile = "$($PSScriptRoot)\settings.txt"
    #####################################
    
    
    
    ####################################
    ### MAIN LOOP ########################
    $Folders = Get-ChildItem "$($WorkingDir)" -Directory -Name #| Select-Object -Property PSPath | Export-Csv "songs.csv"
    ForEach($Folder in $Folders)
    {
        Write-Host "Adding $($Folder) to CSV file..."
        $fTemp = $Folder
        $fTmp = $Folder
        $fParent = $fTemp | Split-Path -Resolve -Parent
        $fFile = $fTemp | Split-Path -Resolve -Leaf
        $path2Song = $Folder | Select-Object -Property PSChildName, PSParentPath, PSPath
        $pathSong = "$($fParent)\$($fFile)"
        write-host "..\$($fParent)\$($fFile)" | out-file packsongs.txt -Append
        out-file -InputObject $pathSong -FilePath packsongs.txt -Append
        Export-Csv -InputObject $path2Song -Path ".\songs.csv" -Append -NoTypeInformation
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

}


####################################
### FUNCTIONS ########################
function ShowBanner()
{
    write-host ""
    write-host '||[ ' -ForegroundColor Red -NoNewline #-BackgroundColor Black
    write-host 'CH Song Manager' -ForegroundColor DarkRed -NoNewline #-BackgroundColor Black
    write-host ' ]||' -ForegroundColor Red #-BackgroundColor Black
    write-host "          by Zanzo          `n" -ForegroundColor DarkRed #-BackgroundColor Black
}
