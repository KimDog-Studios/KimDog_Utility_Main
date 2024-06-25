# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\lib"

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
            '1' {ETS2_Mods}
            '2' {ATS_Mods}
            '3' {FS22_Mods}
            '4' {ETS2_Mods
                ATS_Mods
                FS22_Mods
                }
            '5' {
                . .\main.ps1
            }
        }
    } while ($choice -ne '5')
}

GameMenu