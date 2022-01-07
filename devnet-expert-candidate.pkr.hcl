packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

variables {
   SUDOPASS = "devnet"
}


source "vmware-iso" "ubuntu20-04" {
  iso_url          = "ubuntu-20.04.3-desktop-amd64.iso"
  iso_checksum     = "sha256:5FDEBC435DED46AE99136CA875AFC6F05BDE217BE7DD018E1841924F71DB46B5"
  ssh_username     = "devnet"
  ssh_password     = "devnet"
  ssh_timeout      = "30m"
  shutdown_command = "echo 'devnet' | sudo -S shutdown -P now"
  disk_size        = 40000
  # guest_os_type    = "Ubuntu 64-bit"
  vm_name   = "DevNet Expert Candidate VM"
  cpus      = 4
  cores     = 2
  memory    = 4096
  boot_wait = "75s"
  boot_command = [
    "<tab><tab><enter><wait20>",
    "<tab><tab><tab><tab><tab><tab><enter><wait20>",
    "<tab><tab> <tab><tab><tab><enter><wait20><tab><tab><tab><tab><enter><wait20><tab><enter><wait20><tab><tab><tab><enter><wait20>",
    "DevNet Expert<tab>",
    "devnet<tab>",
    "devnet<tab>",
    "devnet<tab>",
    "devnet<tab>",
    "<tab><tab><enter><wait20>",
    "<wait15m><tab><enter><wait5><enter>",
    "<wait60><enter><wait5>devnet<enter><wait60>",
    "<leftSuper><wait5>",
    "terminal<enter><wait5>",
    "sudo -i<enter>",
    "devnet<enter><wait5>",
    "apt update && apt install openssh-server -y<enter><wait120>",
    "echo 'devnet     ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
  ]
}

build {
  sources = ["sources.vmware-iso.ubuntu20-04"]
  provisioner "file" {
    source      = "requirements.txt"
    destination = "/tmp/requirements.txt"
  }

provisioner "file" {
  source = "nso-installer.bin"
  destination = "/tmp/nso-installer.bin"
}


  provisioner "shell" {
    execute_command   = "chmod +x {{ .Path }}; '{{ .Vars }} {{ .Path }}'"
    script            = "bootstrap.sh"
    pause_before      = "15s"
    timeout           = "30m"
    expect_disconnect = true
  }

  # post-processor "shell-local" { script = "compress.ps1" }

}
