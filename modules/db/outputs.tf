output "database_cluster_name" {
  value       = google_sql_database_instance.spacelift.name
  description = "Name of the database cluster."
}

output "connection_string" {
  value       = "postgres://${google_sql_user.spacelift-backend-iam-user.name}@127.0.0.1/${google_sql_database.spacelift.name}"
  description = "Connection string to the database."
}

