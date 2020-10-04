provider "google" {
  project = var.project_id
  region  = var.region
}
provider "google" {
  project = var.project_id
  region  = "europe-west1"
  alias   = "eu"
}

terraform {
  backend "gcs" {
    bucket = "imelnik1-exit_task"
    prefix = "ansible/"
  }
}

module "network" {
  source       = "./modules/network"
  network_name = var.network_name
  auto_create_subnetworks= true
}

module "firewall" {
  source       = "./modules/firewall"
  network_name = var.network_name
  custom_rules = var.custom_rules
  depends_on   = [module.network]
}

module "test_webapp_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "test-webapp"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "test",
    instance = "web"
  }
  tags       = ["web", "test"]
  depends_on = [module.network]
}
module "test_db_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "test-db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "test",
    instance = "db"
  }
  tags       = ["db", "test"]
  depends_on = [module.network]
}

module "test_check_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "test-check"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "test",
    instance = "web"
  }
  tags       = ["web", "test"]
  depends_on = [module.network]
}

module "prod_webapp_instance" {
  providers = {
    google = google.eu
  }
  source      = "./modules/instance"
  zone        = "europe-west1-b"
  name        = "prod-webapp"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "prod",
    instance = "web"
  }
  tags       = ["web", "prod"]
  depends_on = [module.network]
}
module "prod_db_instance" {
  providers = {
    google = google.eu
  }
  zone        = "europe-west1-b"
  source      = "./modules/instance"
  name        = "prod-db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "prod",
    instance = "db"
  }
  tags       = ["db", "prod"]
  depends_on = [module.network]
}

module "prod_check_instance" {
  providers = {
    google = google.eu
  }
  zone        = "europe-west1-b"
  source      = "./modules/instance"
  name        = "prod-check"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  labels = {
    env      = "test",
    instance = "web"
  }
  tags       = ["web", "test"]
  depends_on = [module.network]
}