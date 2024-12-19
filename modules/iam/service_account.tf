locals {
  node_service_account_email = var.enable_gke ? google_service_account.gke-nodes[0].email : var.node_service_account.email
}

resource "google_service_account" "gke-nodes" {
  count        = var.enable_gke ? 1 : 0
  account_id   = "spacelift-gke-nodes-${var.seed}"
  display_name = "A service account used by Spacelift GKE nodes"
}

resource "google_project_iam_member" "gke-nodes_container-defaultNodeServiceAccount" {
  count   = var.enable_gke ? 1 : 0
  role    = "roles/container.defaultNodeServiceAccount"
  project = var.project
  member  = "serviceAccount:${google_service_account.gke-nodes[0].email}"
}

resource "google_project_iam_member" "gke-nodes_artifactregistry-reader" {
  role    = "roles/artifactregistry.reader"
  project = var.project
  member  = "serviceAccount:${local.node_service_account_email}"
}

resource "google_service_account" "spacelift-backend" {
  account_id   = "${var.app_service_account_name}-${var.seed}"
  display_name = "A service account used by spacelift backend pods to access GCP services"
}

resource "google_project_iam_member" "spacelift-backend_service-account-token-creator" {
  role    = "roles/iam.serviceAccountTokenCreator"
  project = var.project
  member  = "serviceAccount:${google_service_account.spacelift-backend.email}"
}
