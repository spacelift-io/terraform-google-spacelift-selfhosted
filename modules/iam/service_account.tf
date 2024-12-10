resource "google_service_account" "gke-nodes" {
  account_id   = "spacelift-gke-nodes"
  display_name = "A service account used by Spacelift GKE nodes"
}

resource "google_project_iam_binding" "gke-nodes_container-defaultNodeServiceAccount" {
  members = [
    "serviceAccount:${google_service_account.gke-nodes.email}",
  ]
  role    = "roles/container.defaultNodeServiceAccount"
  project = var.project
}

resource "google_project_iam_binding" "gke-nodes_artifactregistry-reader" {
  members = [
    "serviceAccount:${google_service_account.gke-nodes.email}",
  ]
  role    = "roles/artifactregistry.reader"
  project = var.project
}

resource "google_service_account" "spacelift-backend" {
  account_id   = "spacelift-backend"
  display_name = "A service account used by spacelift backend pods to access GCP services"
}

resource "google_service_account_iam_binding" "spacelift-backend_workload-identity" {
  role = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project}.svc.id.goog[spacelift/spacelift-backend]"
  ]
  service_account_id = google_service_account.spacelift-backend.id
}

resource "google_project_iam_binding" "spacelift-backend_service-account-token-creator" {
  role = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:${google_service_account.spacelift-backend.email}",
  ]
  project = var.project
}
