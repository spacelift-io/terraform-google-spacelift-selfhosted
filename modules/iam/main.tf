

data "google_project" "default" {
  project_id = var.project
}

resource "google_project_iam_member" "servicenetworking_role" {
  project = var.project
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.default.number}@service-networking.iam.gserviceaccount.com"
}