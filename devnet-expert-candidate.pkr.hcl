packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "ubuntu20-04" {
  iso_url          = "ubuntu-20.04.3-desktop-amd64.iso"
  iso_checksum     = "sha256:5FDEBC435DED46AE99136CA875AFC6F05BDE217BE7DD018E1841924F71DB46B5"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "30m"
  shutdown_command = "shutdown -P now"
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
    "<wait15m><enter><wait5><enter>",
    "<enter>devnet<enter>",
    "<leftSuper>",
    "terminal<enter>",
    "sudo -i<enter>",
    "devnet<enter>",
    "apt update && apt install openssh-server -y<wait120>"
  ]
}

build {
  sources = ["sources.vmware-iso.ubuntu20-04"]
}
