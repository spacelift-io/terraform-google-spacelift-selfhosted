resource "google_project_iam_binding" "cloudsql-client" {
  members = [
    "serviceAccount:${var.backend_service_account_email}",
  ]
  role    = "roles/cloudsql.client"
  project = var.project
  condition {
    expression  = "resource.name == 'projects/${var.project}/instances/${google_sql_database_instance.spacelift.name}' && resource.type == 'sqladmin.googleapis.com/Instance'"
    title       = google_sql_database_instance.spacelift.name
    description = "Limit the scope only to self-hosted DB instance"
  }
}

resource "google_project_iam_binding" "cloudsql-instance-user" {
  members = [
    "serviceAccount:${var.backend_service_account_email}",
  ]
  role    = "roles/cloudsql.instanceUser"
  project = var.project
  condition {
    expression  = "resource.name == 'projects/${var.project}/instances/${google_sql_database_instance.spacelift.name}' && resource.type == 'sqladmin.googleapis.com/Instance'"
    title       = google_sql_database_instance.spacelift.name
    description = "Limit the scope only to self-hosted DB instance"
  }
}
