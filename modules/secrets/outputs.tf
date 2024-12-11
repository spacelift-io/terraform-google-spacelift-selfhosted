output "db_root_password" {
  value       = random_password.db-root-password.result
  sensitive   = true
  description = "Root password of the database."
}

output "db_root_password_secret_id" {
  value       = google_secret_manager_regional_secret.db-root-password.id
  description = "ID of the secret containing the root password of the database."
}

output "license_token_secret_id" {
  value       = google_secret_manager_regional_secret.self-hosted-license.id
  description = "ID of the secret containing the license token."
}
