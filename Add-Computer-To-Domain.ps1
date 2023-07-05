#In this script:

#1. The `Get-Credential` cmdlet is used to prompt for admin credentials. The credentials will be stored in the `$credentials` variable.
#2. The `Read-Host` cmdlet is used to prompt for the new computer name. The entered name will be stored in the `$newComputerName` variable.
#3. The `Add-Computer` cmdlet is used to join the computer to the domain. It takes the domain name, admin credentials, new computer name, and the `-Restart` parameter to automatically restart the computer after joining the domain.

#Make sure to replace `"yourdomain.com"` with the actual domain name you want to join.

#Remember to run this script with administrative privileges to ensure the necessary permissions for adding the computer to the domain.


# Prompt for admin credentials
$credentials = Get-Credential -Message "Enter admin credentials for joining the domain"

# Prompt for new computer name
$newComputerName = Read-Host -Prompt "Enter the new computer name"

# Add the computer to the domain
Add-Computer -DomainName "yourdomain.com" -Credential $credentials -NewName $newComputerName -Restart
