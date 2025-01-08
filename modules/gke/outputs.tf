output "gke_cluster_name" {
  value       = length(google_container_cluster.spacelift) == 1 ? google_container_cluster.spacelift[0].name : ""
  description = "The name of the GKE cluster"
}
