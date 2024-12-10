output "gke_service_account_email" {
  value       = google_service_account.gke-nodes.email
  description = "The email of the service account used by GKE nodes"
}

output "backend_service_account_email" {
  value       = google_service_account.spacelift-backend.email
  description = "The email of the service account used by the Spacelift backend"
}
