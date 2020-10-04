provider "google" {
  project = var.project_id
  region  = var.region
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
}

module "subnet" {
  source = "./modules/subnets"
  subnets = [
    {
      subnet_name   = "public-subnet"
      subnet_ip     = "10.4.1.0/24"
      subnet_region = "us-central1"
  }]
  network_name = var.network_name
  depends_on   = [module.network]
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
  subnet_name = var.webapp_subnet_name
  labels = {
    env      = "test",
    instance = "web"
  }
  tags       = ["web", "test"]
  depends_on = [module.subnet]
}
module "test_db_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "test-db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  labels = {
    env      = "test",
    instance = "db"
  }
  tags       = ["db", "test"]
  depends_on = [module.subnet]
}

module "prod_webapp_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "prod-webapp"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  labels = {
    env      = "prod",
    instance = "web"
  }
  tags       = ["web", "prod"]
  depends_on = [module.subnet]
}
module "prod_db_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "prod-db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  labels = {
    env      = "prod",
    instance = "db"
  }
  tags       = ["db", "prod"]
  depends_on = [module.subnet]
}