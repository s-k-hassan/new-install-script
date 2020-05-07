#!/bin/bash

# Install Packages
sudo apt-get install git curl apt-transport-https open-vm-tools golang -y

# Install VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code
rm packages.microsoft.gpg

# Install Powershell for Linux
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo add-apt-repository universe
sudo apt-get install -y powershell
rm packages-microsoft-prod.deb

# Install PowerCLI for VMware
pwsh -command set-psrepository -Name PSGalley -InstallationPolicy Trusted
pwsh -command install-module vmware.powercli

# Remove Firefox
sudo apt-get remove firefox -y

# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install Lastpass
google-chrome https://chrome.google.com/webstore/detail/lastpass-free-password-ma/hdokiejnpimakedhajhdlcegeplioahd

# Update everything
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# Reboot
sudo shutdown -r now
