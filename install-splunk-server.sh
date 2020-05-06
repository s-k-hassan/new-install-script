#! /bin/bash

# Install Powershell for Linux
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo add-apt-repository universe
sudo apt-get install -y powershell
rm packages-microsoft-prod.deb

# Install Open-SSH Server
sudo apt-get install openssh-server -y
sudo service ssh start

# Download Splunk and Install
wget -O splunk-installer.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.3&product=splunk&filename=splunk-8.0.3-a6754d8441bf-linux-2.6-amd64.deb&wget=true'
sudo mkdir /opt/splunk
sudo mv splunk-installer.deb /opt/splunk/
cd /opt/splunk
sudo dpkg -i splunk-installer.deb

# Start Splunk for First Run and Enable Autostart
cd /opt/splunk/bin
./splunk start --accept-license --answer-yes
sudo ./splunk stop
#touch /opt/splunk/etc/system/local/user-seed.conf
#echo "Password for Splunk node"
#read splunkpass
echo "[user_info]
USERNAME = admin
PASSWORD = password
" >> /opt/splunk/etc/system/local/user-seed.conf
sudo ./splunk enable boot-start -systemd-managed 1

# Download Finance API monitoring scripts
cd /opt/splunk/etc/apps/search/bin/
wget -O get-stock-values.ps1 'https://raw.githubusercontent.com/s-k-hassan/new-install-script/master/get-stock-values.ps1'
sudo chmod +x get-stock-values.ps1
mkdir /home/splunk/alphavantagedl/
mkdir /home/splunk/alphavantagemon/
echo "API Key for Alphavantage"
read apikey
echo $apikey >> /home/splunk/key.txt

# Create add script sources to input.conf
mkdir /opt/splunk/etc/apps/search/local/
touch /opt/splunk/etc/apps/search/local/inputs.conf
echo "[script:///opt/splunk/etc/apps/search/bin/get-stock-values.ps1]
disabled = false
interval = 6000
sourcetype = csv
source = script://./bin/get-stock-values.ps1" >> /opt/splunk/etc/apps/search/local/inputs.conf

# Start Splunk
sudo /opt/splunk/bin/splunk start
