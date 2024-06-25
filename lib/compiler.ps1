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

# List of vcredist versions to check
$vcredist_versions = @(
    "2005", "2008", "2010", "2012", "2013", "2015", "2017", "2019", "2022"
)

# Function to check if a vcredist is installed
function Is_VcredistInstalled {
    param (
        [string]$version
    )
    $regPath = "HKLM:\SOFTWARE\Classes\Installer\Products\*"
    $keys = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue

    foreach ($key in $keys) {
        if ($key.PSChildName -match $version) {
            return $true
        }
    }
    return $false
}

# Function to check all required vcredists
function Check_AllVcredists {
    param (
        [array]$versions
    )
    $missingVcredists = @()
    foreach ($version in $versions) {
        if (-not (Is_VcredistInstalled -version $version)) {
            $missingVcredists += $version
        }
    }
    return $missingVcredists
}

# Path to your batch script
$batchScriptPath = ".\lib\All_Visual_C\install_all.bat"

# Check for missing vcredists
$missingVcredists = Check-AllVcredists -versions $vcredist_versions

if ($missingVcredists.Count -eq 0) {
    Write-Output "All required vcredists are installed."
}
else {
    Write-Output "The following vcredists are missing: $missingVcredists"
    Write-Output "Running batch script to install missing vcredists..."
    Start-Process -FilePath $batchScriptPath -Wait
    Write-Output "Installation completed. Please verify if all vcredists are installed."
}

# GitHub URL
$gistUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/main.ps1"
Invoke-WebRequest -URI $gistUrl | Invoke-Expression