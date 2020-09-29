variable "network_name" {
  default = "default"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}