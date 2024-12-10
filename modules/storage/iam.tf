resource "google_storage_bucket_iam_member" "buckets" {
  for_each = toset([
    google_storage_bucket.spacelift-large-queue-messages.name,
    google_storage_bucket.spacelift-metadata.name,
    google_storage_bucket.spacelift-modules.name,
    google_storage_bucket.spacelift-policy-inputs.name,
    google_storage_bucket.spacelift-run-logs.name,
    google_storage_bucket.spacelift-states.name,
    google_storage_bucket.spacelift-uploads.name,
    google_storage_bucket.spacelift-user-uploaded-workspaces.name,
    google_storage_bucket.spacelift-workspace.name,
    google_storage_bucket.spacelift-deliveries.name,
  ])
  bucket = each.value
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.backend_service_account_email}"
}

resource "google_project_iam_audit_config" "object-storage" {
  project = var.project
  service = "storage.googleapis.com"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}
