output "gke_service_account_email" {
  value       = length(google_service_account.gke-nodes) == 1 ? google_service_account.gke-nodes[0].email : ""
  description = "The email of the service account used by GKE nodes"
}

output "backend_service_account_email" {
  value       = google_service_account.spacelift-backend.email
  description = "The email of the service account used by the Spacelift backend"
}

output "backend_service_account_id" {
  value       = google_service_account.spacelift-backend.id
  description = "The ID of the service account used by the Spacelift backend"
}
