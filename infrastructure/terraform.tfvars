project_id           = "devops-lab-summer"
region               = "us-central1"
zone                 = "us-central1-c"
network_name         = "webapp-network"
ssh_username         = "centos"
ssh_key              = "~/.ssh/id_rsa.pub"
webapp_instance_name = "webapp-server"
webapp_subnet_name   = "public-subnet"
custom_rules = {
  extarnal-firewall = {
    action  = "allow"
    ranges  = ["0.0.0.0/0"]
    sources = []
    targets = ["web"]
    rules = [
      {
        protocol = "icmp"
        ports    = []
      },
      {
        protocol = "tcp"
        ports    = ["22", "8080", "80", "3306"]
      }
    ]
  },
  internal-firewall = {
    action  = "allow"
    ranges  = ["10.4.1.0/24"]
    sources = []
    targets = []
    rules = [
      {
        protocol = "icmp"
        ports    = []
      },
      {
        protocol = "tcp"
        ports    = ["0-65535"]
      },
      {
        protocol = "udp"
        ports    = ["0-65535"]
      }
    ]
  }
}