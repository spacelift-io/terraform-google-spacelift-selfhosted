resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "spacelift" {
  depends_on = [google_service_networking_connection.private_vpc_connection]

  name             = "spacelift-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_14"

  # Please note that Spacelift application is authenticating passwordless via IAM,
  # but this is a mandatory parameter.
  root_password = var.db_root_password

  settings {
    edition           = var.database_edition
    tier              = var.database_tier
    availability_type = "ZONAL"
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = "true"
      transaction_log_retention_days = 7
    }
    ip_configuration {
      ipv4_enabled    = true
      private_network = var.network_link
    }
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    database_flags {
      name  = "max_connections"
      value = "1034"
    }
  }

  deletion_protection = var.database_deletion_protection
}

resource "google_sql_database" "spacelift" {
  name     = "spacelift-db"
  instance = google_sql_database_instance.spacelift.name
}

resource "google_sql_user" "spacelift-backend-iam-user" {
  name     = trimsuffix(var.backend_service_account_email, ".gserviceaccount.com")
  instance = google_sql_database_instance.spacelift.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}
