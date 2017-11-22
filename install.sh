#!/bin/bash

# Yowsup 2 Installer
# Version: 1.0.0
# Status: Alpha

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

clear
echo -e "${NC}"
cat<<"EOF"
   ____  __    _                 __
  / __ \/ /_  (_)___ ____  ___  / /__
 / / / / __ \/ / __ `/ _ \/ _ \/ //_/
/ /_/ / /_/ / / /_/ /  __/  __/ ,<
\____/_.___/_/\__, /\___/\___/_/|_|
             /____/
EOF
echo "YOWSUP 2.0 Installer"
echo "Version: 1.0.0"
echo -e "Status: ${ORANGE}Alpha${NC}"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo ''
echo -n "This installer will update the system first, do you wish to continue? [Y/N]: "
read continue_reply

if [[ $continue_reply =~ [Nn]$ ]]; then
  exit
fi

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -n "Updating System: "
apt-get -qq update
apt-get -qq upgrade
echo -e "${GREEN}[Complete]${NC}"

echo "----- Installing Dependencies -----"
echo -n "Python Dateutil: "
apt-get -qq install python-dateutil
echo -e "${GREEN}[Complete]${NC}"

echo -n "Python Setup Tools: "
apt-get -qq install python-setuptools
echo -e "${GREEN}[Complete]${NC}"

echo -n "Python Dev: "
apt-get -qq install python-dev
echo -e "${GREEN}[Complete]${NC}"

echo -n "Libevent Dev: "
apt-get -qq install libevent-dev
echo -e "${GREEN}[Complete]${NC}"

echo -n "Ncurses Dev: "
apt-get -qq install ncurses-dev
echo -e "${GREEN}[Complete]${NC}"

echo -n "BeautifulSoup: "
apt-get -qq install python-beautifulsoup
echo -e "${GREEN}[Complete]${NC}"

echo "----- Downloading YOWSUP -----"
echo -n "Cloning Repo: "
git clone --quiet https://github.com/tgalal/yowsup.git
echo -e "${GREEN}[Complete]${NC}"

echo "----- Building Configuration -----"
echo -n "Downloading Link Builder: "
wget --quiet https://raw.githubusercontent.com/Obigeek/YOWSUP_Installer/master/link_builder.py
echo -e "${GREEN}[Complete]${NC}"

echo -n "Downloading Version Helper: "
wget --quiet https://raw.githubusercontent.com/Obigeek/YOWSUP_Installer/master/version_helper.py
echo -e "${GREEN}[Complete]${NC}"

echo -n "Downloading MD5 Helper: "
wget --quiet https://raw.githubusercontent.com/Obigeek/YOWSUP_Installer/master/md5_helper.py
echo -e "${GREEN}[Complete]${NC}"

echo -n "Downloading Configuration Builder: "
wget --quiet https://raw.githubusercontent.com/Obigeek/YOWSUP_Installer/master/conf_builder.py
echo -e "${GREEN}[Complete]${NC}"

echo -n "Getting Version: "
version=$(python version_helper.py WhatsApp.apk 2>&1)
echo -e "${ORANGE}$version${NC}"

echo -n "Getting MD5: "
MD5=$(python md5_helper.py WhatsApp.apk 2>&1)
echo -e "${ORANGE}$MD5${NC}"

cd yowsup/yowsup/env/

echo -n "Modifying Configuration File: "
python conf_builder.py $version $MD5
echo -e "${GREEN}[Complete]${NC}"

echo -n "Deleting Old Configuration File: "
rm env_andriod.py
mv env_andriod_new.py env_andriod.py
cd ../../
echo -e "${GREEN}[Complete]${NC}"

echo -n "Building: "
python setup.py build
echo -e "${GREEN}[Complete]${NC}"

echo -n "Installing: "
python setup.py install
echo -e "${GREEN}[Complete]${NC}"

echo "----- Cleaning Up -----"
cd ../
echo -n "Deleting Files: "
rm conf_builder.py
rm version_helper.py
rm md5_helper.py
rm link_builder.py
rm WhatsApp.apk
echo -e "${GREEN}[Complete]${NC}"

echo
echo -n "Would you like to remove Beautiful Soup? [Y/N]: "
read remove_beautiful

if [[ $beautiful_soup =~ [Yy]$ ]]; then
  apt-get -qq remove --purge python-beautifulsoup
  echo -e "Beautiful Soup: ${GREEN}[Removed]${NC}"
else
  echo -e "Beautiful Soup: ${GREEN}[Still Installed]${NC}"
fi

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -e "${GREEN}YOWSUP 2 Installation Complete${NC}"
echo -n "Would you like to configure the installation? [Y/N]: "
read configure

if [[ $configure =~ [Yy]$ ]]; then
  echo -n "What is your country code? "
  read cc
  echo -n "What is your Phone Number? (NOT including Country Code)"
  read phone
  echo -n "What is your carrier MCC? "
  read mcc
  echo -n "What is your carrier MNC? "
  read mnc
  echo
  echo -n "Sending Request: "
  yowsup-cli registration --requestcode sms --phone $cc$phone --cc $cc --mcc $mcc --mnc $mnc -E android
  echo -e "${GREEN}[Sent]${NC}"
  echo
  echo -n "Please enter your verification code: "
  read ver_code
  yowsup-cli registration --register $ver_code --phone $cc$phone --cc $cc -E android > config

  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  echo -e "${GREEN}YOWSUP 2 Registration Complete${NC}"
  echo -e "You can now use the generated config"
else
  echo "Please manually configure YOWSUP using it's build in commands. You may manually remove this install file now."
  exit
fi
