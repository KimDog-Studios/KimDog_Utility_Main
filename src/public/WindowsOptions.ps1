# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\src"
$mainUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/src/public/main.ps1"

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
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName WindowsBase

    # Load XML from GitHub
    $xmlFileUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/xaml/InputXML.xml"
    $xmlContent = Invoke-RestMethod -Uri $xmlFileUrl

    # Load XAML from XML content
    $xmlReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xmlContent.OuterXml))
    $readerContext = [Windows.Markup.XamlReader]::CreateContext((New-Object System.Xaml.XamlSchemaContext))
    $form = [Windows.Markup.XamlReader]::Load($xmlReader, $readerContext)

    # Get controls from XAML
    $checkedListBox = $form.FindName("checkedListBox")
    $installSelectedButton = $form.FindName("installSelectedButton")
    $installAllButton = $form.FindName("installAllButton")
    $upgradeAllButton = $form.FindName("upgradeAllButton")
    $closeButton = $form.FindName("closeButton")

    # Populate CheckedListBox with software names
    $jsonFileUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"
    $jsonContent = Invoke-RestMethod -Uri $jsonFileUrl
    $appList = $jsonContent.apps

    $itemsToAdd = @()
    foreach ($app in $appList) {
        $itemsToAdd += "$($app.name) - $($app.description)"
    }
    $sortedItems = $itemsToAdd | Sort-Object

    foreach ($item in $sortedItems) {
        $checkedListBox.Items.Add($item)
    }

    # Event handlers
    $installSelectedButton.Add_Click({
            foreach ($index in $checkedListBox.SelectedItems) {
                $selectedApp = $appList[$index]
                Write-Output "Installing $($selectedApp.name)..."
                Start-Process -FilePath "winget" -ArgumentList "install --id $($selectedApp.id) --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            }
            [System.Windows.MessageBox]::Show("Installation completed.", "Installation")
        })

    $installAllButton.Add_Click({
            foreach ($app in $appList) {
                Write-Output "Installing $($app.name)..."
                Start-Process -FilePath "winget" -ArgumentList "install --id $($app.id) --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            }
            [System.Windows.MessageBox]::Show("Installation completed.", "Installation")
        })

    $upgradeAllButton.Add_Click({
            $upgradeAllButton.IsEnabled = $false
            Write-Output "Upgrading all applications..."
            Start-Process -FilePath "winget" -ArgumentList "upgrade --all" -NoNewWindow -Wait
            [System.Windows.MessageBox]::Show("Upgrade completed.", "Upgrade")
            $upgradeAllButton.IsEnabled = $true
        })

    $closeButton.Add_Click({
            $form.Close()
        })

    # Show the form
    $form.ShowDialog()
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