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
    $softwareDir = "$cabFiles\Softwares_001.cab"
    $extractPath = "$scriptDir\Temp"

    if (-not (Test-Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath | Out-Null
    }

    # Check if the CAB file exists and extract it
    if (Test-Path $softwareDir) {
        Expand -F:* $softwareDir $extractPath
        Write-Host "Software extracted successfully."
    } else {
        Write-Host "Software CAB file does not exist."
        return
    }

    # Call a batch script
    $batchScript = Join-Path $scriptDir "install.bat"
    if (Test-Path $batchScript) {
        Write-Host "Calling batch script: $batchScript"
        Start-Process -FilePath $batchScript -Wait
        Write-Host "Batch script executed."
        
        # Remove the extracted folder after installation
        Remove-Item -Path $extractPath -Recurse -Force
        Write-Host "Cleanup of extracted software files complete."
    } else {
        Write-Host "Batch script not found in the extracted folder."
    }
    Start-Sleep -Seconds 5
    Clear-Host
}

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
            '1' { . .\GameOptions.ps1 }
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