terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  folder_id                = var.folder_id
}

data "yandex_compute_image" "greetings" {
  family    = var.yc_image_family  
  folder_id = var.folder_id 
}

data "yandex_vpc_subnet" "greetings" {
  name      = "greetings-${var.zone}"
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "greetings-vm" {
  name = "greetings-vm"
  zone = var.zone

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.greetings.id  
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.greetings.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" 
  }
}

output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = yandex_compute_instance.greetings-vm.network_interface.0.nat_ip_address
}
