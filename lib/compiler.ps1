# Check if Winget is installed
$wingetInstalled = $false

# Check if the winget command exists
if ($null -ne (Get-Command -Name winget -ErrorAction SilentlyContinue)) {
    $wingetInstalled = $true
    Write-Output "Winget is already installed."
}

# Install Winget if it's not already installed
if (-not $wingetInstalled) {
    Write-Output "Winget is not installed. Downloading and installing..."

    # Define the URL to the latest stable release of winget-cli
    $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"

    # Define the path where to save the installer
    $wingetInstallerPath = "$env:TEMP\winget-cli.appxbundle"

    # Download the installer
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetInstallerPath

    # Install winget silently
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", "Add-AppxPackage -Path '$wingetInstallerPath' -ForceApplicationShutdown" -Wait
    
    # Check if installation was successful
    if ($null -eq (Get-Command -Name winget -ErrorAction SilentlyContinue)) {
        Write-Error "Failed to install Winget."
    }
    else {
        Write-Output "Winget installation completed successfully."
    }

    # Clean up the installer
    Remove-Item -Path $wingetInstallerPath -Force
}

# GitHub URL
$gistUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/main.ps1"

Invoke-WebRequest -URI $gistUrl | Invoke-Expression