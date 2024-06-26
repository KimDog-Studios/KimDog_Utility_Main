# Define the base directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$cabFiles = "$scriptDir\src"
$mainUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/src/main.ps1"

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
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Define the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Software Installer"
    $form.Size = New-Object System.Drawing.Size(600, 400)  # Initial size
    $form.StartPosition = "CenterScreen"
 
    # Create a TableLayoutPanel for automatic scaling
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.RowCount = 5  # Updated row count to accommodate new button
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 70)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 8)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 8)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 8)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 6)))

    # Create a CheckedListBox to display software options
    $checkedListBox = New-Object System.Windows.Forms.CheckedListBox
    $checkedListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    $checkedListBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
    $checkedListBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $checkedListBox.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)  # Set font size
    $checkedListBox.ItemHeight = 24  # Increase item height for more spacing

    # Populate CheckedListBox with software names
    $jsonFileUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"
    $jsonContent = Invoke-RestMethod -Uri $jsonFileUrl
    $appList = $jsonContent.apps

    $itemsToAdd = @()
    foreach ($app in $appList) {
        $itemsToAdd += "$($app.name) - $($app.description)"
    }

    # Sort items alphabetically
    $sortedItems = $itemsToAdd | Sort-Object

    # Add sorted items to CheckedListBox
    $checkedListBox.Items.AddRange($sortedItems)

    # Create an Install Selected button
    $installSelectedButton = New-Object System.Windows.Forms.Button
    $installSelectedButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $installSelectedButton.Text = "Install Selected"
    $installSelectedButton.AutoSize = $true  # Ensure button size is based on text content

    $installSelectedButton.Add_Click({
            # Install selected applications
            foreach ($index in $checkedListBox.CheckedIndices) {
                $selectedApp = $appList[$index]
                Write-Output "Installing $($selectedApp.name)..."
                winget install --id $selectedApp.id --silent --accept-package-agreements --accept-source-agreements
            }
            [System.Windows.Forms.MessageBox]::Show("Installation completed.", "Installation")
        })

    # Create an Install All button
    $installAllButton = New-Object System.Windows.Forms.Button
    $installAllButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $installAllButton.Text = "Install All"
    $installAllButton.AutoSize = $true  # Ensure button size is based on text content

    $installAllButton.Add_Click({
            # Install all applications
            foreach ($app in $appList) {
                Write-Output "Installing $($app.name)..."
                winget install --id $app.id --silent --accept-package-agreements --accept-source-agreements
            }
            [System.Windows.Forms.MessageBox]::Show("Installation completed.", "Installation")
        })

    # Create an Upgrade All button
    $upgradeAllButton = New-Object System.Windows.Forms.Button
    $upgradeAllButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $upgradeAllButton.Text = "Upgrade All"
    $upgradeAllButton.AutoSize = $true  # Ensure button size is based on text content

    $upgradeAllButton.Add_Click({
            # Disable the Upgrade All button while processing
            $upgradeAllButton.Enabled = $false

            # Run 'winget upgrade --all' command
            Write-Output "Upgrading all applications..."
            Start-Process -FilePath "winget" -ArgumentList "upgrade --all"  -NoNewWindow -Wait

            # Show completion message in the UI thread
            [System.Windows.Forms.MessageBox]::Show("Upgrade completed.", "Upgrade")

            # Enable the Upgrade All button after completion
            $upgradeAllButton.Enabled = $true
        })

    # Create a Close button
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $closeButton.Text = "Close"
    $closeButton.AutoSize = $true  # Ensure button size is based on text content

    $closeButton.Add_Click({
            $form.Close()
        })

    # Add controls to TableLayoutPanel
    $tableLayoutPanel.Controls.Add($checkedListBox, 0, 0)
    $tableLayoutPanel.Controls.Add($installSelectedButton, 0, 1)
    $tableLayoutPanel.Controls.Add($installAllButton, 0, 2)
    $tableLayoutPanel.Controls.Add($upgradeAllButton, 0, 3)
    $tableLayoutPanel.Controls.Add($closeButton, 0, 4)

    # Add TableLayoutPanel to the form
    $form.Controls.Add($tableLayoutPanel)

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