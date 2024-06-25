# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\lib"
$mainUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/main.ps1"

function DownloadDocumentsCab {
    Set-Location $scriptDir\GoogleDriveDownloader.py
}

function Documents {
    $cabFile = "$cabFiles\Documents_001.cab"
    $extractPath = "$env:USERPROFILE\Documents\"

    # Check if the CAB file exists and extract it
    if (Test-Path $cabFile) {
        Expand -F:* $cabFile $extractPath
        Write-Host "Documents extracted successfully."
    }
    else {
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
    }
    else {
        Write-Host "Finished copying all the Files from Extracted Documents folder..."
    }

    # Optional: Clean up extracted files after copying
    # Remove-Item -Path $extractPath -Recurse -Force
    # Write-Host "Cleanup of extracted files complete."

    Start-Sleep -Seconds 5
    Clear-Host
}

function Software {
    # Define the URL to the JSON file
    $jsonFileUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"

    # Fetch the JSON file content
    $jsonContent = Invoke-RestMethod -Uri $jsonFileUrl

    # Extract the list of apps
    $appList = $jsonContent.apps

    # Loop through each app ID and install it using winget
    foreach ($app in $appList) {
        Write-Output "Installing $app..."
        winget install --id $app --silent --accept-package-agreements --accept-source-agreements
    }
}   

function WindowsMenu {
    do {
        Clear-Host
        Write-Host "Please choose an option:"
        Write-Host "1. Copy Document Files to User Documents Folder"
        Write-Host "2. Install and Run Software"
        Write-Host "3. Go to Previous Menu"
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            '1' { 
                    DownloadDocumentsCab
                    Documents 
                }
            '2' { Software }
            '3' { Invoke-WebRequest -URI $mainUrl | Invoke-Expression }
        }
    } while ($choice -ne '3')
}

WindowsMenu