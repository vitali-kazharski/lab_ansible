variable "network_name" {
  default = "vpc"
}

variable "routing_mode" {
  type        = string
  default     = "REGIONAL"
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  default     = false
}