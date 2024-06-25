# GitHub URL
$gistUrl = "https://gist.githubusercontent.com/yourusername/raw/yourgistID/yourscript.ps1"

Invoke-RestMethod -Uri $gistUrl | Invoke-Expression