variable "instance_count" {
  default = "1"
}
variable "name" {
  default = "default"
}
variable "zone" {
  default = ""
}
variable "machine_type" {
  default = "n1-standard-1"
}
variable "ssh_key" {
  default = ""
}
variable "startup_script" {
  default = ""
}
variable "source_image" {
  default = "centos-cloud/centos-7"
}
variable "network_name" {
  default = "default"
}
variable "subnet_name" {
  default = ""
}
variable "ext_ip" {
  default = true
}
variable "tags" {
  default = [""]
}
variable "labels" {
  type        = map(string)
  default = {
  }
}