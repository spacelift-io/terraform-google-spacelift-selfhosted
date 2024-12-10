output "large_queue_messages_bucket" {
  value       = google_storage_bucket.spacelift-large-queue-messages.name
  description = "Name of the bucket used for storing large queue messages"
}

output "metadata_bucket" {
  value       = google_storage_bucket.spacelift-metadata.name
  description = "Name of the bucket used for storing run metadata"
}

output "modules_bucket" {
  value       = google_storage_bucket.spacelift-modules.name
  description = "Name of the bucket used for storing Spacelift modules"
}

output "policy_inputs_bucket" {
  value       = google_storage_bucket.spacelift-policy-inputs.name
  description = "Name of the bucket used for storing policy inputs"
}

output "run_logs_bucket" {
  value       = google_storage_bucket.spacelift-run-logs.name
  description = "Name of the bucket used for storing run logs"
}

output "states_bucket" {
  value       = google_storage_bucket.spacelift-states.name
  description = "Name of the bucket used for storing stack states"
}

output "uploads_bucket" {
  value       = google_storage_bucket.spacelift-uploads.name
  description = "Name of the bucket used for storing user uploads"
}

output "user_uploaded_workspaces_bucket" {
  value       = google_storage_bucket.spacelift-user-uploaded-workspaces.name
  description = "Name of the bucket used for storing user uploaded workspaces. This is used for the local preview feature."
}

output "workspace_bucket" {
  value       = google_storage_bucket.spacelift-workspace.name
  description = "Name of the bucket used for storing stack workspace data"
}

output "deliveries_bucket" {
  value       = google_storage_bucket.spacelift-deliveries.name
  description = "Name of the bucket used for storing audit trail delivery data"
}
