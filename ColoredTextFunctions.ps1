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