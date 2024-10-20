variable "service_account_key_file" {
  description = "Yandex Cloud service account key file in json format"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
}

variable "ssh_public_key" {
  description = "SSH public key to connect to new created instance"
}

variable "zones" {
  description = "Yandex Cloud default Zones for provisioned resources"
  type        = map
  default     = {
    vm-a = "ru-central1-a"
    vm-b = "ru-central1-b"
  }
}

variable "yc_image_family" {
  description = "VM Image family"
  default     = "greetings" 
}

variable "cluster_size" {
  default = 1
}

variable "instance_cores" {
  description = "Cores per one instance"
  default     = "2"
}

variable "instance_memory" {
  description = "Memory in GB per one instance"
  default     = "2"
}
