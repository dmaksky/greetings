packer {
  required_plugins {
    yandex = {
      version = "~> 1"
      source  = "github.com/hashicorp/yandex"
    }
  }
}

variables {
  yc_folder_id = env("YC_FOLDER_ID") 
  yc_token     = env("YC_TOKEN") 
}

source "yandex" "image_builder" {
  token               = var.yc_token
  folder_id           = var.yc_folder_id
  source_image_family = "ubuntu-2404"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
}

build {
  sources = ["source.yandex.image_builder"] 
  provisioner "file" {
    source      = "greetings"
    destination = "/tmp/greetings"
  }
  provisioner "file" {
    source      = "pipeline/packer/greetings.service" 
    destination = "/etc/systemd/system/greetings.service" 
  }
  provisioner "shell" {
    script = "pipeline/packer/provisioner.sh"
  }
}
