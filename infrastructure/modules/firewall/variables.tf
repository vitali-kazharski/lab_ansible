variable "network_name" {
}
variable "custom_rules" {
  default     = {}
  type = map(object({
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
}