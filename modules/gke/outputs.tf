output "gke_cluster_name" {
  value       = google_container_cluster.spacelift.name
  description = "The name of the GKE cluster"
}
