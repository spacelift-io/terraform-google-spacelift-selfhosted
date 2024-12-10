locals {
  apis = [
    "artifactregistry",
    "compute",
    "container",
    "servicenetworking",
    "sql-component",
    "sqladmin",
    "secretmanager",
  ]
}

resource "google_project_service" "service" {
  for_each = toset(local.apis)
  service = "${each.value}.googleapis.com"
  timeouts {
    create = "30m"
  }
  disable_on_destroy = false
}
