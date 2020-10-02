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

module "webapp_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = var.webapp_instance_name
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  tags        = ["web", "public", "dev"]
  depends_on  = [module.subnet]
}
module "db_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  tags        = ["web", "public", "dev"]
  depends_on  = [module.subnet]
}
module "check-db_instance" {
  source      = "./modules/instance"
  zone        = var.zone
  name        = "check-db"
  ssh_key     = "${var.ssh_username}:${file(var.ssh_key)}"
  subnet_name = var.webapp_subnet_name
  tags        = ["web", "public", "dev"]
  depends_on  = [module.subnet]
}