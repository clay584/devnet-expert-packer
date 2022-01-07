# devnet-expert-packer

Generates a VM for Cisco DevNet Expert Exam. This was done on Windows with VMware Workstation 16.2.
You can also build it with VirtualBox using [these docs](https://www.packer.io/docs/builders/virtualbox/iso),
but I used VMware Workstation as that is what I have installed on my machine.

## Prerequisites

1. Clone this repo and go into the directory: `git clone https://github.com/clay584/devnet-expert-packer.git && cd devnet-expert-packer`
2. Download and Install VMware Workstation 16.
3. Download and extract the Packer EXE from [here](https://www.packer.io/downloads) and copy it into this directory.
4. Download Ubuntu 20.04.3-desktop-amd64.iso from [here](https://ubuntu.com/download/desktop) and copy it into this directory.
5. Download Cisco NSO installer from [here](https://developer.cisco.com/docs/nso/#!getting-and-installing-nso/getting-nso) and copy it into this directory. Rename the file to `nso-installer-signed.bin`.

## Creation of the VM


1. .\packer.exe build .\devnet-expert-candidate.pkr.hcl
