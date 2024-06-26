Write-Host "=================================================================="
Write-Host "--                                             Scripts must be run as Administrator                                                     ---" 
Write-Host "-- Running as Admin Automitcically if not do it Manually | Right-Click Start -> Terminal(Admin) ---" 
Write-Host "=================================================================="

# URL of the remote script on GitHub
$remoteScriptUrl = "https://raw.githubusercontent.com/KimDog-Studios/KimDog_Utility_Main/main/src/private/compiler.ps1"

# Download the remote script content
$scriptContent = Invoke-WebRequest -Uri $remoteScriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# Encode the script content to Base64
$encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))

# Start the script with elevated privileges
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedScript" -Verb runAs

# Close the current non-admin PowerShell session
exit