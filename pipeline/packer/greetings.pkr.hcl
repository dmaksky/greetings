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
  yc_subnet_id                = env("YC_SUBNET_ID")
}

locals {
  current_date = formatdate("YYYYMMDD-hhmmss", timestamp())
}

source "yandex" "image_builder" {
  service_account_key_file = var.yc_service_account_key_file
  folder_id                = var.yc_folder_id
  subnet_id                = var.yc_subnet_id
  zone                     = "ru-central1-a"

  image_name               = "greetings-${local.current_date}"
  image_family             = "greetings"
  image_description        = "Image for greetings app based on Ubuntu 24-04 LTS"

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
