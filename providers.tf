terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
 local = {
      source = "hashicorp/local"
    }
  }
  required_version = "~>1.13.0"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
