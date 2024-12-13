output "database_cluster_name" {
  value       = google_sql_database_instance.spacelift.name
  description = "Name of the database cluster."
}

output "database_connection_name" {
  value       = google_sql_database_instance.spacelift.connection_name
  description = "Connection name of the database cluster."
}

output "database_dns_name" {
  value       = google_sql_database_instance.spacelift.dns_name
  description = "DNS name of the database cluster."
}

output "database_private_ip_address" {
  value       = google_sql_database_instance.spacelift.private_ip_address
  description = "Private IP address of the database cluster."
}

output "connection_string_for_sidecar_proxy" {
  value       = "postgres://${google_sql_user.spacelift-backend-iam-user.name}@127.0.0.1/${google_sql_database.spacelift.name}"
  description = "Connection string to the database."
}

output "database_root_password" {
  value       = random_password.db-root-password.result
  sensitive = true
}
