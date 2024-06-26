# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\src"

# URL to the configuration file on GitHub
$jsonFileUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"

# Fetch the configuration file directly
try {
    $config = Invoke-RestMethod -Uri $jsonFileUrl
    Write-Host "Config file fetched successfully."
}
catch {
    Write-Host "Failed to fetch config file."
    Write-Host $_.Exception.Message
    exit 1
}

# Access the URLs from the JSON configuration
$mainUrl = $config.urls.mainUrl

if ([string]::IsNullOrEmpty($mainUrl)) {
    Write-Host "Main script URL is null or empty in the config file."
    exit 1
}

function ETS2_Mods {
    $extractPath = "$env:USERPROFILE\Documents\Euro Truck Simulator 2\mod"

    Expand-Archive -Path "$cabFiles\ETS2_Mods_001.zip" -DestinationPath "$extractPath" -Force
    Expand-Archive -Path "$cabFiles\ETS2_Mods_002.zip" -DestinationPath "$extractPath" -Force

    Start-Sleep -Seconds 5
    Clear-Host
}

function FS22_Mods {
    $extractPath = "$env:USERPROFILE\Documents\My Games\FarmingSimulator2022\mods"

    Expand-Archive -Path "$cabFiles\FS22_Mods_001.zip" -DestinationPath "$extractPath" -Force

    Start-Sleep -Seconds 5
    Clear-Host
}

function ATS_Mods {
    $extractPath = "$env:USERPROFILE\Documents\American Truck Simulator\mod"

    Expand-Archive -Path "$cabFiles\ATS_Mods_001.zip" -DestinationPath "$extractPath" -Force

    Start-Sleep -Seconds 5
    Clear-Host
}

function GameMenu {
    do {
        Clear-Host
        Write-Host "Please choose an option:"
        Write-Host "1. Copy ETS 2 Mods"
        Write-Host "2. Copy ATS Mods"
        Write-Host "3. Copy FS 22 Mods"
        Write-Host "4. Copy All Mods"
        Write-Host "5. Go to Previous Menu"
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            '1' { ETS2_Mods }
            '2' { ATS_Mods }
            '3' { FS22_Mods }
            '4' {
                ETS2_Mods
                ATS_Mods
                FS22_Mods
            }
            '5' { Invoke-WebRequest -URI $mainUrl | Invoke-Expression }
        }
    } while ($choice -ne '5')
}

GameMenu
