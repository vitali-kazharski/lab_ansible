# ==================== Create instance =============================

resource "google_compute_instance" "default" {
  count        = var.instance_count
  name         = "${var.name}-instance-${count.index + 1}"
  zone         = var.zone
  machine_type = var.machine_type
  tags         = var.tags
  metadata = {
    ssh-keys = var.ssh_key
  }
  metadata_startup_script = var.startup_script
  boot_disk {
    initialize_params {
      image = var.source_image
    }
  }
  network_interface {
    network    = var.subnet_name == "" ? var.network_name : ""
    subnetwork = var.subnet_name
    dynamic "access_config" {
      for_each = var.ext_ip ? [""] : []
      content {
        nat_ip = access_config.value
      }
    }
  }
}