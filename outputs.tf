output "region" {
  value       = var.region
  description = "The region the Spacelift infrastructure is deployed in"
}

output "project" {
  value       = var.project
  description = "The project the Spacelift infrastructure is deployed in"
}

### IAM ###

output "gke_service_account_email" {
  value       = module.iam.gke_service_account_email
  description = "Email of the service account used by GKE nodes"
}

output "backend_service_account_email" {
  value       = module.iam.backend_service_account_email
  description = "Email of the service account meant to be used by the Spacelift backend"
}

### Network ###

output "network_id" {
  value       = module.network.network_id
  description = "ID of the network the Spacelift infrastructure is deployed in"
}

output "network_name" {
  value       = module.network.network_name
  description = "Name of the network the Spacelift infrastructure is deployed in"
}

output "network_link" {
  value       = module.network.network_link
  description = "Self link (URI) of the network the Spacelift infrastructure is deployed in"
}

output "gke_subnetwork_id" {
  value       = module.gke.gke_subnetwork_id
  description = "Subnetwork ID of the GKE cluster"
}

output "gke_subnetwork_name" {
  value       = module.gke.gke_subnetwork_name
  description = "Subnetwork name of the GKE cluster"
}

output "gke_cluster_name" {
  value       = module.gke.gke_cluster_name
  description = "Name of the GKE cluster"
}

output "gke_public_v4_address" {
  value       = module.network.gke_public_v4_address
  description = "Public IPv4 address for GKE Ingresses"
}

output "gke_public_v6_address" {
  value       = module.network.gke_public_v6_address
  description = "Public IPv6 address for GKE Ingresses"
}

output "mqtt_ipv4_address" {
  value       = module.gke.mqtt_ipv4_address
  description = "The IPv4 address of the MQTT service. It is empty if 'create_compute_address_for_mqtt' is set to false."
}

output "mqtt_ipv6_address" {
  value       = module.gke.mqtt_ipv6_address
  description = "The IPv6 address of the MQTT service. It is empty if 'create_compute_address_for_mqtt' is set to false."
}

### Artifact store ###

output "artifact_repository_url" {
  value       = module.artifacts.repository_url
  description = "URL of the Docker repository"
}

### Database ###
output "db_instance_name" {
  value       = module.db.instance_name
  description = "Name of the database instance"
}

output "db_connection_name" {
  value       = module.db.database_connection_name
  description = "Connection name of the database cluster. Needs to be passed to the Cloud SQL sidecar proxy See https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine#proxy"
}

output "db_private_ip_address" {
  value       = module.db.database_private_ip_address
  description = "Private IP address of the database instance."
}

output "db_database_name" {
  value = module.db.database_name
  description = "Internal PostgreSQL db name inside the Cloud SQL instance."
}

output "db_root_password" {
  value       = module.db.database_root_password
  description = "The database root password"
  sensitive = true
}

### Storage ###

output "large_queue_messages_bucket" {
  value       = module.storage.large_queue_messages_bucket
  description = "Name of the bucket used for storing large queue messages"
}

output "metadata_bucket" {
  value       = module.storage.metadata_bucket
  description = "Name of the bucket used for storing run metadata"
}

output "modules_bucket" {
  value       = module.storage.modules_bucket
  description = "Name of the bucket used for storing Spacelift modules"
}

output "policy_inputs_bucket" {
  value       = module.storage.policy_inputs_bucket
  description = "Name of the bucket used for storing policy inputs"
}

output "run_logs_bucket" {
  value       = module.storage.run_logs_bucket
  description = "Name of the bucket used for storing run logs"
}

output "states_bucket" {
  value       = module.storage.states_bucket
  description = "Name of the bucket used for storing stack states"
}

output "uploads_bucket" {
  value       = module.storage.uploads_bucket
  description = "Name of the bucket used for storing user uploads"
}

output "user_uploaded_workspaces_bucket" {
  value       = module.storage.user_uploaded_workspaces_bucket
  description = "Name of the bucket used for storing user uploaded workspaces. This is used for the local preview feature."
}

output "workspace_bucket" {
  value       = module.storage.workspace_bucket
  description = "Name of the bucket used for storing stack workspace data"
}

output "deliveries_bucket" {
  value       = module.storage.deliveries_bucket
  description = "Name of the bucket used for storing audit trail delivery data"
}

output "shell" {
  sensitive = true
  value = templatefile("${path.module}/env.tftpl", {env: {
    GCP_PROJECT: var.project,
    GCP_LOCATION: var.region,
    SERVER_DOMAIN: var.website_domain,
    WEBHOOKS_ENDPOINT: "https://${var.website_domain}/webhooks",

    # IAM
    BACKEND_SERVICE_ACCOUNT: module.iam.backend_service_account_email,

    # Network
    PUBLIC_IP_NAME: module.network.gke_public_v4_name,
    PUBLIC_IPV6_NAME: module.network.gke_public_v6_name,

    # Artifacts
    ARTIFACT_REGISTRY_DOMAIN: module.artifacts.repository_domain,
    ARTIFACT_REGISTRY_REPOSITORY: module.artifacts.repository_url,
    BACKEND_IMAGE: "${module.artifacts.repository_url}/spacelift-backend",
    LAUNCHER_IMAGE: "${module.artifacts.repository_url}/spacelift-launcher"

    # Buckets
    OBJECT_STORAGE_BUCKET_DELIVERIES=module.storage.deliveries_bucket,
    OBJECT_STORAGE_BUCKET_LARGE_QUEUE_MESSAGES=module.storage.large_queue_messages_bucket,
    OBJECT_STORAGE_BUCKET_MODULES=module.storage.modules_bucket,
    OBJECT_STORAGE_BUCKET_POLICY_INPUTS=module.storage.policy_inputs_bucket,
    OBJECT_STORAGE_BUCKET_RUN_LOGS=module.storage.run_logs_bucket,
    OBJECT_STORAGE_BUCKET_STATES=module.storage.states_bucket,
    OBJECT_STORAGE_BUCKET_USER_UPLOADED_WORKSPACES=module.storage.user_uploaded_workspaces_bucket,
    OBJECT_STORAGE_BUCKET_WORKSPACE=module.storage.workspace_bucket,
    OBJECT_STORAGE_BUCKET_METADATA=module.storage.metadata_bucket
    OBJECT_STORAGE_BUCKET_UPLOADS=module.storage.uploads_bucket
    OBJECT_STORAGE_BUCKET_UPLOADS_URL="https://storage.googleapis.com"

    # Database
    DATABASE_NAME=module.db.database_name
    DATABASE_USER=module.db.database_iam_user
    DATABASE_CONNECTION_NAME=module.db.database_connection_name
    DB_ROOT_PASSWORD=module.db.database_root_password

    #GKE
    GKE_CLUSTER_NAME=module.gke.gke_cluster_name
  }})
}
