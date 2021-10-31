# Colored/Styled Text Functions #
#######################
function txtColor([string]$txt,[int]$color)
{
    $inStr = $txt | out-host
    $inColor = $color | out-host
    
    if($color -eq 0)
    {
        write-host $txt -ForegroundColor Black -NoNewline
    }elseif($color -eq 1)
    {
        write-host $txt -ForegroundColor White -NoNewline
    }
    
    #if($color -eq $null){write-host $txt -NoNewline} #null
}

function uiTextBar([string]$txt,[string]$type)
{
    if($($type -eq "Alert") -or $($type -eq "alert") -or $($type -eq "a") -or $($type -eq "A") -or $($type -eq "1"))
    {
        write-host "!|[ ALERT: " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Yellow -BackgroundColor Black   
    } #Alert
    elseif($($type -eq "Error") -or $($type -eq "error") -or $($type -eq "E") -or $($type -eq "e") -or $($type -eq "2"))
    {
        write-host "!|[ ERROR: " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    } #Error
    elseif($($type -eq "Info") -or $($type -eq "info") -or $($type -eq "I") -or $($type -eq "i") -or $($type -eq "3"))
    {
        write-host "!|[ INFO: " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkCyan -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    } #Info
    elseif($($type -eq "Note") -or $($type -eq "note") -or $($type -eq "N") -or $($type -eq "n") -or $($type -eq "0"))
    {
        write-host "!|[ NOTE: " -NoNewline -ForegroundColor Gray -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkGray -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Gray -BackgroundColor Black
    } #Note
    elseif($($type -eq "Red") -or $($type -eq "red") -or $($type -eq "R") -or $($type -eq "r") -or $($type -eq "4"))
    {
        write-host "!|[ " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    } #Red
    else 
    {
        write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
        write-host "$($type): " -NoNewline -ForegroundColor DarkRed -BackgroundColor Black
        write-host $($txt) -NoNewline -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    } #Default

}##END########################UI#uiTextError###

function uiTextBlock([string]$txt,[int]$style)
{
    if($style -eq 1)
    {
        write-host "!|[ " -NoNewline -ForegroundColor Red -BackgroundColor Black
        write-host $($txt) -NoNewline -BackgroundColor Black
        write-host " ]|!" -NoNewline -ForegroundColor Red -BackgroundColor Black
    } # Red/Default
    elseif($style -eq 2)
    {
        write-host "!|[ " -ForegroundColor Red -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkRed -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Red -BackgroundColor Black -NoNewline
    } # Red/DarkRed
    elseif($style -eq 3)
    {
        write-host "!|[ " -ForegroundColor Green -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Green -BackgroundColor Black -NoNewline
    } # Green/Default
    elseif($style -eq 4)
    {
        write-host "!|[ " -ForegroundColor Green -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkGreen -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Green -BackgroundColor Black -NoNewline
    } # Green/DarkGreen
    elseif($style -eq 5)
    { 
        write-host "!|[ " -ForegroundColor Blue -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Blue -BackgroundColor Black -NoNewline
    }# Blue/Default
    elseif($style -eq 6)
    { 
        write-host "!|[ " -ForegroundColor Blue -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkBlue -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Blue -BackgroundColor Black -NoNewline
    }# Blue/DarkBlue
    elseif($style -eq 7)
    {
        write-host "!|[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Yellow -BackgroundColor Black -NoNewline
    } # Yellow/Default
    elseif($style -eq 8)
    { 
        write-host "!|[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkYellow -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Yellow -BackgroundColor Black -NoNewline
    }# Yellow/DarkYellow
    elseif($style -eq 9)
    { 
        write-host "!|[ " -ForegroundColor Magenta -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Magenta -BackgroundColor Black -NoNewline
    }# Magenta/Default
    elseif($style -eq 10)
    {
        write-host "!|[ " -ForegroundColor Magenta -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkMagenta -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Magenta -BackgroundColor Black -NoNewline
    } # Cyan/DarkMagenta
    elseif($style -eq 11)
    {
        write-host "!|[ " -ForegroundColor Cyan -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Cyan -BackgroundColor Black -NoNewline
    } # Cyan/Default
    elseif($style -eq 12)
    {
        write-host "!|[ " -ForegroundColor Cyan -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkCyan -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Cyan -BackgroundColor Black -NoNewline
    } # Cyan/DarkCyan
    elseif($style -eq 13)
    { 
        write-host "!|[ " -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Gray -BackgroundColor Black -NoNewline
    }# Gray/Default
    elseif($style -eq 14)
    {
        write-host "!|[ " -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor DarkGray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor Gray -BackgroundColor Black -NoNewline
    } # Gray/DarkGray
    elseif($style -eq 15)
    { 
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline
    }# White/Default
    elseif($style -eq 16)
    { 
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline
    }# White/Gray
    elseif($style -eq 0)
    {
        write-host "!|[ " -ForegroundColor Black -BackgroundColor White -NoNewline
        write-host $($txt) -ForegroundColor Black -BackgroundColor White -NoNewline
        write-host " ]|!" -ForegroundColor Black -BackgroundColor White -NoNewline
    }# Black/White
    else #DEFAULT
    { 
        write-host "!|[ " -ForegroundColor White -BackgroundColor Black -NoNewline
        write-host $($txt) -ForegroundColor Gray -BackgroundColor Black -NoNewline
        write-host " ]|!" -ForegroundColor White -BackgroundColor Black -NoNewline  
    } # Red/Default

}##END########################UI#TextBarRed###