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
  account_id   = var.app_service_account_name
  display_name = "A service account used by spacelift backend pods to access GCP services"
}

resource "google_project_iam_binding" "spacelift-backend_service-account-token-creator" {
  role = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:${google_service_account.spacelift-backend.email}",
  ]
  project = var.project
}
