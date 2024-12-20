resource "google_service_account_iam_binding" "spacelift-backend_workload-identity" {
  role = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project}.svc.id.goog[${var.k8s_namespace}/${var.app_service_account_name}]"
  ]
  service_account_id = var.backend_service_account_id
}
