#### VARIABLES #################
$dirFiles = 'G:\.CloneHero\c3db'
#$dirFiles = ''
##############################

# Ask the user for the directory of the partial json files...
#$input = read-host "Enter the path to the partial scraped json data."
#$dirFiles = $input
# Ask the user for the prefix of the filenames...
write-host "Enter the prefix of the filenames..."
write-host "(Ex: c3db____.json, c3db is the prefix)" -BackgroundColor Black
$input2 = read-host "Enter filename prefix."
$filePrefix = $input2

#$baseFile = "$($dirFiles)\$($filePrefix).json"
$combinedFile = "$($dirFiles)\$($filePrefix)_combined.json"

#ForEach($js in $(Get-ChildItem "$($dirFiles)\$($filePrefix)*.json"))
#{
#    $tmpBase = Get-Content -Path $baseFile -Raw | ConvertFrom-Json
#    $js1 = Get-Content -Path $js -Raw | ConvertFrom-Json
#     $tmpBase + $js1 | ConvertTo-Json -Depth 5 | out-file -FilePath $baseFile
#}

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