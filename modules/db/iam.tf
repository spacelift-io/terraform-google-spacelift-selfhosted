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

data "google_project" "default" {
  project_id = var.project
}

resource "google_project_iam_member" "servicenetworking_role" {
  project = var.project
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.default.number}@service-networking.iam.gserviceaccount.com"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  depends_on = [google_project_iam_member.servicenetworking_role]

  network                 = var.compute_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.database-private-ip.name]

  # There is an annoying bug during 'terraform destroy' command where the peering connection
  # cannot be deleted sometimes due to an obscure error: https://github.com/hashicorp/terraform-provider-google/issues/16275
  # Error: Unable to remove Service Networking Connection, err: Error waiting for Delete Service Networking Connection: Error code 9, message: Failed to delete connection; Producer services (e.g. CloudSQL, Cloud Memstore, etc.) are still using this connection.
  # When setting it to ABANDON, it'll leave the resource dangling.
  # However, when we destroy the compute network, that'll remove the peering connection as well
  # so eventually, it'll be cleaned up.
  deletion_policy = "ABANDON"
}
