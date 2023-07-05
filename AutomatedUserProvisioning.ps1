<#
In this script:
    - The Get-Credential cmdlet is used to prompt for admin credentials to perform Active Directory operations.
    - The Read-Host cmdlet is used to prompt for user details, including first name, last name, username, and password.
    - The $groupNames variable is an array that contains the names of the groups to which the user should be assigned.
    - The $permissions variable specifies the permissions to be set for the user (e.g., Modify, Read).
    - The New-ADUser cmdlet is used to create the user in Active Directory, with the provided details and credentials.
    - The Add-ADGroupMember cmdlet is used to add the user to the specified groups.
    - The script then retrieves the user's Distinguished Name (DN) and sets the specified permissions using the Get-Acl, New-Object, and Set-Acl cmdlets.

Remember to replace "yourdomain.com" with the actual domain name, and modify the group names, permissions, and any other parameters to fit your specific environment and requirements.

Ensure that the script is executed with administrative privileges to perform the necessary Active Directory operations.
#>

# Prompt for admin credentials
$credentials = Get-Credential -Message "Enter admin credentials for Active Directory"

# Prompt for user details
$firstName = Read-Host -Prompt "Enter user's first name"
$lastName = Read-Host -Prompt "Enter user's last name"
$username = Read-Host -Prompt "Enter user's username"
$password = Read-Host -Prompt "Enter user's password" -AsSecureString

# Specify group names
$groupNames = @("Group1", "Group2", "Group3")  # Add or modify group names as needed

# Specify permissions (example: Modify, Read)
$permissions = "Modify", "Read"

# Create user in Active Directory
New-ADUser -SamAccountName $username -GivenName $firstName -Surname $lastName -UserPrincipalName "$username@yourdomain.com" -AccountPassword $password -Enabled $true -Credential $credentials

# Add user to groups
foreach ($groupName in $groupNames) {
    Add-ADGroupMember -Identity $groupName -Members $username -Credential $credentials
}

# Set permissions for user
$adUser = Get-ADUser -Identity $username -Credential $credentials
$adUser | ForEach-Object {
    $userDN = $_.DistinguishedName
    foreach ($permission in $permissions) {
        $acl = Get-Acl -Path "AD:\$userDN"
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule ($username, $permission, "Allow")
        $acl.AddAccessRule($ace)
        Set-Acl -Path "AD:\$userDN" -AclObject $acl
    }
}
