output "network" {
  value       = google_compute_network.network
}

output "network_name" {
  value       = google_compute_network.network.name
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
}