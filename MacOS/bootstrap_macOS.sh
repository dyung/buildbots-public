#!/bin/bash

# Extract the OS version number
OS_MAJOR_VERSION=`sw_vers | grep ProductVersion | cut -f 2 -w | cut -f 1 -d .`
echo OS_MAJOR_VERSION=${OS_MAJOR_VERSION}

if [ ${OS_MAJOR_VERSION} = "14" ]; then
    echo Detected major OS version 14
    curl -L -o Command_Line_Tools_for_Xcode.dmg "https://www.dropbox.com/scl/fi/0ynk1d9an2tq1mupfpmg5/Command_Line_Tools_for_Xcode_15.3.dmg?rlkey=sy4j889pm7isdsaimvac6sbq3&st=gziptetf&dl=0"
elif [ ${OS_MAJOR_VERSION} = "15" ]; then
    echo "Unsupported major OS version (${OS_MAJOR_VERSION})"
    exit 1
else
    echo "Unsupported major OS version (${OS_MAJOR_VERSION})"
    exit 1
fi

# Mount the disk image
hdiutil attach -mountpoint xcode_tools Command_Line_Tools_for_Xcode.dmg

# Run the installer
sudo installer -verbose -package "xcode_tools/Command Line Tools.pkg" -target /

# Dismount the disk image
hdutil detach xcode_tools

# Delete the installer disk image
rm Command_Line_Tools_for_Xcode.dmg

# Add Homebrew and python3 binaries to path
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"

# Upgrade pip
sudo pip3 install --upgrade pip

# Install Ansible
pip3 install ansible

# Enable ssh access
sudo systemsetup -setremotelogin on

# Enable screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# Create the ssh directories
mkdir ~/.ssh
chmod 700 ~/.ssh
mkdir ~/.ssh/github
chmod 755 ~/.ssh/github

# Lock down ssh key correctly
touch ~/.ssh/github/id_rsa
chmod 600 ~/.ssh/github/id_rsa

# Create the ssh config file
touch ~/.ssh/config
chmod 644 ~/.ssh/config
echo "Host github.com" > ~/.ssh/config
echo "\tHostname github.com" >> ~/.ssh/config
echo "\tUser git" >> ~/.ssh/config
echo "\tPreferredAuthentications publickey" >> ~/.ssh/config
echo "\tIdentityFile ~/.ssh/github/id_rsa" >> ~/.ssh/config

echo "Copy over the ssh key to ~/.ssh/github/id_rsa"

exit 0