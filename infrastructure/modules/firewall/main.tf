resource "google_compute_firewall" "custom" {
  for_each                = var.custom_rules
  name                    = each.key
  network                 = var.network_name
  source_ranges           = each.value.ranges
  source_tags             = each.value.sources
  target_tags             = each.value.targets

  dynamic "allow" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "allow"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}
