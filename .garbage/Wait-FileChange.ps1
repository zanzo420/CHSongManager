#$Action = 'Write-Output "The watched file was changed"' # The action to execute upon file change
$File = "C:\Users\Zanzo\AppData\Roaming\Clone Hero Launcher\gameFiles\currentsong.txt" # The file to watch
$Action = 'NowPlaying'
$global:FileChanged = $false

function Wait-FileChange {
    param( [string]$File, [string]$Action ) 
    ## VARIABLES ####################
    $FilePath = Split-Path $File -Parent
    $FileName = Split-Path $File -Leaf
    $ScriptBlock = [scriptblock]::Create($Action)
    ###############################

    # Create watcher to watch the file for changes
    $Watcher = New-Object IO.FileSystemWatcher $FilePath, $FileName -Property @{
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }
    $onChange = Register-ObjectEvent $Watcher Changed -Action {$global:FileChanged = $true}

    # if no changes, sleep...
    while ($global:FileChanged -eq $false) {Start-Sleep -Milliseconds 100}

    & $ScriptBlock 
    Unregister-Event -SubscriptionId $onChange.Id
}

Wait-FileChange -File $File -Action $Action
