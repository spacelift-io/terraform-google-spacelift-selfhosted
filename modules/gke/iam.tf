resource "google_service_account_iam_binding" "spacelift-backend_workload-identity" {
  # The cluster creates the serviceAccount, so we need to wait until it finishes
  depends_on = [google_container_cluster.spacelift]

  role = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project}.svc.id.goog[${var.k8s_namespace}/spacelift-backend]"
  ]
  service_account_id = var.backend_service_account_id
}
