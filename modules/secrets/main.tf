resource "random_password" "db-root-password" {
  length = 20
}

resource "google_secret_manager_regional_secret" "db-root-password" {
  secret_id = "spacelift-db-root-password"
  location  = var.region
  labels    = var.labels
}

resource "google_secret_manager_regional_secret_version" "secret-version-basic" {
  secret      = google_secret_manager_regional_secret.db-root-password.id
  secret_data = random_password.db-root-password.result
}

resource "google_secret_manager_regional_secret" "self-hosted-license" {
  secret_id = "self-hosted-license"
  location  = var.region
  labels    = var.labels
}

resource "google_secret_manager_regional_secret_version" "self-hosted-license-secret-version-basic" {
  secret      = google_secret_manager_regional_secret.self-hosted-license.id
  secret_data = var.license_token
}
