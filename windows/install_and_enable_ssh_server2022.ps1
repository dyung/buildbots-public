# Enabling ssh server on Windows Server 2022:
# (From https://www.server-world.info/en/note?os=Windows_Server_2022&p=ssh&f=1)

# get available name of OpenSSH
#Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'

# install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# start sshd service
Start-Service -Name "sshd" 

# set [Automatic] for Startup
Set-Service -Name "sshd" -StartupType Automatic 

# verify settings
Get-Service -Name "sshd" | Select-Object * 

# if Windows Firewall is running, allow 22/TCP
# however, 22/TCP is generally allowed by OpenSSH installer, so it does not need to do the follows manually
New-NetFirewallRule -Name "SSH" `
-DisplayName "SSH" `
-Description "Allow SSH" `
-Profile Any `
-Direction Inbound `
-Action Allow `
-Protocol TCP `
-Program Any `
-LocalAddress Any `
-RemoteAddress Any `
-LocalPort 22 `
-RemotePort Any 
