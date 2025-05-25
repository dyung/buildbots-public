#!/bin/sh

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

# Install Homebrew
# NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

