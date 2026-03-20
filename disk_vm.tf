resource "yandex_compute_disk" "storage" {
  count = var.vm_storage_disk_count
  name  = "disk-${count.index + 1}"
  size  = var.vm_storage_disk_size
  zone  = var.default_zone
}

data "yandex_compute_image" "ubuntu_storage" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.vm_web_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_storage_cores
    memory        = var.vm_storage_memory
    core_fraction = var.vm_storage_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_storage.image_id
      size     = var.vm_storage_boot_disk_size
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage
    content {
      disk_id = secondary_disk.value.id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}
