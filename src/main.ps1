$gameOptionsUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/GameOptions.ps1"
$windowsOptionsUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/lib/WindowsOptions.ps1"

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