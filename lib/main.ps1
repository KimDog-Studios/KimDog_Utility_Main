# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\lib"

function Documents {
    $cabFile = "$cabFiles\Documents_001.cab"
    $extractPath = "$env:USERPROFILE\Documents\"

    # Check if the CAB file exists and extract it
    if (Test-Path $cabFile) {
        Expand -F:* $cabFile $extractPath
        Write-Host "Documents extracted successfully."
    } else {
        Write-Host "Documents CAB file does not exist."
        return
    }

    # Proceed with copying items from the extracted Documents folder, excluding the extraction folder
    Write-Host "Copying Items from Extracted Document Folder to the Users Documents! Please wait..."
    $source = Get-ChildItem -Path $extractPath -Exclude "Documents"
    $destination = "$env:USERPROFILE\Documents"
    foreach ($item in $source) {
        Copy-Item -Path $item.FullName -Destination $destination -Recurse -Force
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to copy files!"
    } else {
        Write-Host "Finished copying all the Files from Extracted Documents folder..."
    }

    # Optional: Clean up extracted files after copying
    # Remove-Item -Path $extractPath -Recurse -Force
    # Write-Host "Cleanup of extracted files complete."

    Start-Sleep -Seconds 5
    Clear-Host
}

function Software {
    
}

$gameOptionsUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/GameOptions.ps1"

# Menu function
function Show-Main-Menu {
    do {
        Clear-Host
        Write-Host "Please choose an option:"
        Write-Host "1. Game Menu"
        Write-Host "2. Windows Menu"
        Write-Host "3. Exit"
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            '1' { Invoke-WebRequest -URI $gameOptionsUrl | Invoke-Expression }
            '2' { Software }
            '3' {
                Write-Host "Exiting script..."
                Start-Sleep -Seconds 2
                return
            }
        }
    } while ($choice -ne '3')
}

# Call the menu function
Show-Main-Menu