#Make sure to run this PowerShell script as admin

# Stop any potential Windows Store-related processes
Get-Process -Name "WinStore*" | Stop-Process -Force

# Stop InstallService
Stop-Service -Name "InstallService"

# Wait for a few seconds
Start-Sleep -Seconds 3

# Start InstallService
Start-Service -Name "InstallService"

# Wait for a few more seconds
Start-Sleep -Seconds 5

# Try to reinstall the package after stopping potential processes
Get-AppXPackage *WindowsStore* -AllUsers | Foreach {
    Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
}
