# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\lib"
$mainUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/main.ps1"

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

    Clear-Host
    Write-Host "Choose software to install (`all` to install all):"
    Write-Host ""

    # Display the list of apps for selection
    for ($i = 0; $i -lt $appList.Count; $i++) {
        Write-Host "$($i+1). $($appList[$i].name) - $($appList[$i].description)"
    }
    Write-Host ""

    $choice = Read-Host "Enter app number or 'all' to install all"

    if ($choice -eq 'all') {
        # Install all apps
        foreach ($app in $appList) {
            Write-Output "Installing $($app.name)..."
            winget install --id $app.id --silent --accept-package-agreements --accept-source-agreements
        }
    }
    else {
        # Install selected app
        $selectedApp = $appList[([int]$choice) - 1]
        Write-Output "Installing $($selectedApp.name)..."
        winget install --id $selectedApp.id --silent --accept-package-agreements --accept-source-agreements
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
            '1' { Documents }
            '2' { Software }
            '3' { DownloadDocumentsCab }
            '4' { Invoke-WebRequest -URI $mainUrl | Invoke-Expression }
        }
    } while ($choice -ne '3')
}

WindowsMenu