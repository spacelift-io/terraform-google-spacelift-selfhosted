output "database_name" {
  value       = google_sql_database.spacelift.name
  description = "Name of the database."
}

output "database_iam_user" {
  value       = google_sql_user.spacelift-backend-iam-user.name
  description = "Name of the database IAM user."
}

output "database_connection_name" {
  value       = google_sql_database_instance.spacelift.connection_name
  description = "Connection name of the database."
}

output "database_root_password" {
  value       = random_password.db-root-password.result
  sensitive = true
}
