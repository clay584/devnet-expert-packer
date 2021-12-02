#!/usr/bin/env bash

# Bootstraps all the things located here:
# https://learningnetwork.cisco.com/s/article/devnet-expert-equipment-and-software-list


# Get all the updates for Ubuntu
sudo apt-get update && sudo apt-get upgrade -y

# Install pyenv pre-requisites and build-essential, etc.
sudo apt-get install git make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libedit-dev -y

# Install misc packages
sudo apt install vim telnet curl wget netcat nginx zsh tcsh jq libxml2-utils -y

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
sudo apt-get install ./Downloads/google-chrome-stable_current_amd64.deb

# Install vscode
sudo snap install code --classic

# Install PyCharm Community Edition
sudo snap install pycharm-community --classic

# Install Atom Editor
sudo snap install atom --classic

# Install Postman
sudo snap install postman

# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark
sudo usermod -a -G wireshark $USER
newgrp -

# Install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="$HOME/.pyenv"
a \
export PATH="$PYENV_ROOT/bin:$PATH"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile
echo 'eval "$(pyenv init --path)"' >>~/.profile

echo 'eval "$(pyenv init -)"' >> ~/.bashrc

source ~/.profile

# Install python 3.9 (latest at time of this script was 3.9.9)
pyenv install 3.9.9

# Set the devnet user's default python interpreter to 3.9.9
pyenv global 3.9.9

# Docker & docker compose
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp -

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform -y

