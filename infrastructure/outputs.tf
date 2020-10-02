output "webapp" {
  value = module.webapp_instance.instances_info[0].network_interface[0].access_config[0].nat_ip
}
output "db" {
  value = module.db_instance.instances_info[0].network_interface[0].access_config[0].nat_ip
}
output "check-db" {
  value = module.check-db_instance.instances_info[0].network_interface[0].access_config[0].nat_ip
}