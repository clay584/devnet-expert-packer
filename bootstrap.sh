#!/usr/bin/env bash
set -x
# Bootstraps all the things located here:
# https://learningnetwork.cisco.com/s/article/devnet-expert-equipment-and-software-list


# Get all the updates for Ubuntu
echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get upgrade -y

# Install pyenv pre-requisites and build-essential, etc.
echo "$SUDOPASS" | sudo -S apt-get install git make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libedit-dev -y

# Install misc packages
echo "$SUDOPASS" | sudo -S apt install vim telnet curl wget netcat nginx zsh tcsh jq libxml2-utils -y

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
echo "$SUDOPASS" | sudo -S apt-get install ./Downloads/google-chrome-stable_current_amd64.deb

# Install vscode
echo "$SUDOPASS" | sudo -S snap install code --classic

# Install PyCharm Community Edition
echo "$SUDOPASS" | sudo -S snap install pycharm-community --classic

# Install Atom Editor
echo "$SUDOPASS" | sudo -S snap install atom --classic

# Install Postman
echo "$SUDOPASS" | sudo -S snap install postman

# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
echo "$SUDOPASS" | sudo -S DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark
echo "$SUDOPASS" | sudo -S usermod -a -G wireshark devnet

# Install pyenv
curl https://pyenv.run | bash
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
source ~/.bashrc

# Install python 3.9 (latest at time of this script was 3.9.9)
pyenv install 3.9.9

# Set the devnet user's default python interpreter to 3.9.9
pyenv global 3.9.9

# Docker & docker compose
echo "$SUDOPASS" | sudo -S apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get install docker-ce docker-ce-cli containerd.io -y

echo "$SUDOPASS" | sudo -S groupadd docker
echo "$SUDOPASS" | sudo -S usermod -aG docker devnet

echo "$SUDOPASS" | sudo -S systemctl enable docker.service
echo "$SUDOPASS" | sudo -S systemctl enable containerd.service

echo "$SUDOPASS" | sudo -S curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo "$SUDOPASS" | sudo -S chmod +x /usr/local/bin/docker-compose

# Install Terraform
echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get install -y gnupg software-properties-common curl -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "$SUDOPASS" | sudo -S apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get install terraform -y

# Install kubectl
echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get install -y apt-transport-https ca-certificates curl
echo "$SUDOPASS" | sudo -S curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "$SUDOPASS" | sudo -S apt-get update
echo "$SUDOPASS" | sudo -S apt-get install -y kubectl

# Install telnet client
echo "$SUDOPASS" | sudo -S apt install telnet -y

# Install openssh client
echo "$SUDOPASS" | sudo -S apt install openssh-client -y

# Install Python Requirements
python -m venv ~/venv
source ~/venv/bin/activate
pip install -U pip
mv /tmp/requirements.txt requirements.txt
pip install -r requirements.txt

# Install Cisco ACI Ansible collection
ansible-galaxy collection install cisco.aci:2.1.0

# Install Cisco Network Services Orchestrator (NSO) local installation 5.6
mv /tmp/nso-installer-signed.bin /home/devnet/Downloads
cd /home/devnet/Downloads || return
/bin/sh nso-installer-signed.bin
find . -name "*installer-signed.bin" -exec mv {} nso-installer.bin \;
/bin/sh nso-installer.bin --local-install ~/nso
