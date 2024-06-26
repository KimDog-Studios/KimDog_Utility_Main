Write-Host "Start Script as Administrator"

# URL of the remote JSON configuration file
$configUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"

# Fetch and parse the JSON content from the URL
$config = Invoke-RestMethod -Uri $configUrl

# Access the URL for the remote script from the JSON configuration
$remoteScriptUrl = $config.urls.compilerUrl

# Download the remote script content
$scriptContent = Invoke-WebRequest -Uri $remoteScriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# Encode the script content to Base64
$encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))

# Start the script with elevated privileges
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedScript" -Verb runAs

# Close the current non-admin PowerShell session
Start-Sleep 5
exit