#From https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell&pivots=windows-server-2025
#Starting with Windows Server 2025, OpenSSH is now installed by default. You can also enable or disable the sshd service in Server Manager.

# Start the sshd service
Start-Service sshd

# You can also run the following optional but recommended cmdlet to automatically start SSHD to make sure it stays enabled:
Set-Service -Name sshd -StartupType 'Automatic'

# Finally, run the following command to verify that the SSHD setup process automatically configured the firewall rule:
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
