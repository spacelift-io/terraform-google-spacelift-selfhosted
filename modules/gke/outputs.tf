output "gke_subnetwork_id" {
  value       = google_compute_subnetwork.default.id
  description = "The ID of the subnetwork that the GKE cluster was created in"
}

output "gke_subnetwork_name" {
  value       = google_compute_subnetwork.default.name
  description = "The name of the subnetwork that the GKE cluster was created in"
}

output "gke_cluster_name" {
  value       = google_container_cluster.spacelift.name
  description = "The name of the GKE cluster"
}


