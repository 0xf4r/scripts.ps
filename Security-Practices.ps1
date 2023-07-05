<#PowerShell script that demonstrates how to enforce security best practices by automatically applying security configurations, such as disabling unnecessary services, enabling firewalls, and configuring security policies:

In this script:

1. The `$servicesToDisable` variable contains an array of unnecessary services to be disabled. Customize this list based on your specific requirements.
2. The `foreach` loop iterates over the services in `$servicesToDisable`, disables them by setting their startup type to "Disabled," and stops them forcefully.
3. The `Set-NetFirewallProfile` cmdlet is used to enable the Windows Firewall for all profiles (Domain, Public, and Private).
4. The `$securityOptions` hashtable contains security policy settings and their corresponding values. Modify this hashtable according to your desired security configurations.
5. The second `foreach` loop applies the security policies by querying and modifying the appropriate WMI objects in the "Root/SecurityCenter2" namespace.
6. Finally, the script outputs a completion message.

Please note that this script provides a basic example of security hardening and may require further customization based on your specific security requirements and environment. It is essential to thoroughly test and validate the script in a controlled environment before applying it to production systems.
#>


# Disable unnecessary services
$servicesToDisable = @(
    "Telnet",
    "FTP",
    "NetPipeActivator",
    "W3SVC",
    "SNMP"
)

foreach ($service in $servicesToDisable) {
    Set-Service -Name $service -StartupType Disabled
    Stop-Service -Name $service -Force
}

# Enable Windows Firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

# Configure Security Policies
$securityOptions = @{
    "Interactive logon: Machine inactivity limit" = 900
    "Network access: Do not allow anonymous enumeration of SAM accounts and shares" = 1
    "System cryptography: Force strong key protection for user keys stored on the computer" = 2
}

foreach ($option in $securityOptions.GetEnumerator()) {
    $policy = Get-WmiObject -Namespace "Root/SecurityCenter2" -Class "SecurityOption" | Where-Object { $_.DisplayName -eq $option.Name }
    if ($policy) {
        $policy.SetStringValue($option.Value.ToString())
    }
}

Write-Host "Security hardening completed."
