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

data "yandex_vpc_subnet" "greetings-a" {
  name      = "greetings-${var.zones["vm-a"]}"
  folder_id = var.folder_id
}

data "yandex_vpc_subnet" "greetings-b" {
  name      = "greetings-${var.zones["vm-b"]}"
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "greetings-vm-a" {
  name = "greetings-vm-a"
  zone = var.zones["vm-a"]

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
    subnet_id = data.yandex_vpc_subnet.greetings-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" 
  }
}

resource "yandex_compute_instance" "greetings-vm-b" {
  name = "greetings-vm-b"
  zone = var.zones["vm-b"]

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
    subnet_id = data.yandex_vpc_subnet.greetings-b.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" 
  }
}

resource "yandex_lb_target_group" "greetings" {
  name      = "greetings-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = data.yandex_vpc_subnet.greetings-a.id
    address   = yandex_compute_instance.greetings-vm-a.network_interface.0.ip_address
  }

  target {
    subnet_id = data.yandex_vpc_subnet.greetings-b.id
    address   = yandex_compute_instance.greetings-vm-b.network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "greetings" {
  name = "greeings-lb"

  listener {
    name        = "greetings-listener"
    port        = 80
    target_port = 8000
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.greetings.id

    healthcheck {
      name = "http"
      http_options {
        port = 8000
        path = "/healthy"
      }
    }
  }
}

output "lb_public_ip" {
  description = "The public IP of the LB"
  value = [
    for listener in yandex_lb_network_load_balancer.greetings.listener : 
    [
      for address_spec in listener.external_address_spec : 
      address_spec.address
      if listener.name == "greetings-listener"
    ]
  ][0][0]
}
