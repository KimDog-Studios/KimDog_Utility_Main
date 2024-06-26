Write-Host "Start Script as Administrator"

# URL of the remote JSON configuration file
$configUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/config/config.json"

# Fetch and parse the JSON content from the URL
try {
    $config = Invoke-RestMethod -Uri $configUrl
    Write-Host "Config file fetched successfully."
}
catch {
    Write-Host "Failed to fetch config file."
    Write-Host $_.Exception.Message
    exit 1
}

# Access the URL for the remote script from the JSON configuration
$remoteScriptUrl = $config.urls.compilerUrl

if ([string]::IsNullOrEmpty($remoteScriptUrl)) {
    Write-Host "Compiler URL is null or empty in the config file."
    exit 1
}

# Download the remote script content
try {
    $scriptContent = Invoke-WebRequest -Uri $remoteScriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content
    Write-Host "Script content fetched successfully."
}
catch {
    Write-Host "Failed to fetch script content."
    Write-Host $_.Exception.Message
    exit 1
}

# Encode the script content to Base64
try {
    $encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))
    Write-Host "Script content encoded successfully."
}
catch {
    Write-Host "Failed to encode script content."
    Write-Host $_.Exception.Message
    exit 1
}

# Start the script with elevated privileges
try {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedScript" -Verb runAs
    Write-Host "Started the script with elevated privileges."
}
catch {
    Write-Host "Failed to start the script with elevated privileges."
    Write-Host $_.Exception.Message
    exit 1
}

# Close the current non-admin PowerShell session
Start-Sleep 5
exit