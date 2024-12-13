output "network_id" {
  value       = google_compute_network.default.id
  description = "ID of the Compute network"
}

output "network_name" {
  value       = google_compute_network.default.name
  description = "Name of the Compute network"
}

output "network_link" {
  value       = google_compute_network.default.self_link
  description = "Self link (URI) of the Compute network"
}

output "gke_public_v4_address" {
  value       = google_compute_global_address.gke-public-v4.address
  description = "Public IPv4 address for GKE Ingresses"
}

output "gke_public_v6_address" {
  value       = google_compute_global_address.gke-public-v6.address
  description = "Public IPv6 address for GKE Ingresses"
}
