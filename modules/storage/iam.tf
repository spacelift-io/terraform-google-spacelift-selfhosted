resource "google_storage_bucket_iam_member" "buckets" {
  for_each = local.bucket_names
  bucket   = each.value
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${var.backend_service_account_email}"

  depends_on = [
    google_storage_bucket.spacelift-large-queue-messages,
    google_storage_bucket.spacelift-metadata,
    google_storage_bucket.spacelift-modules,
    google_storage_bucket.spacelift-policy-inputs,
    google_storage_bucket.spacelift-run-logs,
    google_storage_bucket.spacelift-states,
    google_storage_bucket.spacelift-states,
    google_storage_bucket.spacelift-uploads,
    google_storage_bucket.spacelift-user-uploaded-workspaces,
    google_storage_bucket.spacelift-workspace,
    google_storage_bucket.spacelift-deliveries,
  ]
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
