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
$gameOptionsUrl = $config.urls.gameOptionsUrl
$windowsOptionsUrl = $config.urls.windowsOptionsUrl

if ([string]::IsNullOrEmpty($gameOptionsUrl) -or [string]::IsNullOrEmpty($windowsOptionsUrl)) {
    Write-Host "One or both of the URLs are null or empty in the config file."
    exit 1
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
            '1' { Invoke-WebRequest -URI $gameOptionsUrl | Invoke-Expression }
            '2' { Invoke-WebRequest -URI $windowsOptionsUrl | Invoke-Expression }
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