output "webapp-server" {
  value = module.webapp_instance.instances_info[0].network_interface[0].access_config[0].nat_ip
}