# GitHub URL
$gistUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/main.ps1"

Invoke-WebRequest -URI $gistUrl | Invoke-Expression