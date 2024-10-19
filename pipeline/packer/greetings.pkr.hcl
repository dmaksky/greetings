packer {
  required_plugins {
    yandex = {
      version = "~> 1"
      source  = "github.com/hashicorp/yandex"
    }
  }
}

variables {
  yc_folder_id                = env("YC_FOLDER_ID") 
  yc_service_account_key_file = env("YC_ACCOUNT_KEY_FILE")
}

source "yandex" "image_builder" {
  service_account_key_file = var.yc_service_account_key_file
  folder_id                = var.yc_folder_id
  source_image_family      = "ubuntu-24-04-lts"
  ssh_username             = "ubuntu"
  use_ipv4_nat             = "true"
}

build {
  sources = ["source.yandex.image_builder"] 
  provisioner "file" {
    source      = "greetings"
    destination = "/tmp/greetings"
  }
  provisioner "file" {
    source      = "pipeline/packer/greetings.service" 
    destination = "/tmp/greetings.service" 
  }
  provisioner "shell" {
    script = "pipeline/packer/provisioner.sh"
  }
}
