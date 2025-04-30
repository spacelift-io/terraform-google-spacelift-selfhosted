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
  value       = local.network != null ? local.network.id : ""
  description = "ID of the network the Spacelift infrastructure is deployed in. Empty if external network provided."
}

output "network_name" {
  value       = local.network != null ? local.network.name : ""
  description = "Name of the network the Spacelift infrastructure is deployed in. Empty if external network provided."
}

output "network_link" {
  value       = local.network != null ? local.network.self_link : ""
  description = "Self link (URI) of the network the Spacelift infrastructure is deployed in. Empty if external network provided."
}

output "gke_subnetwork_id" {
  value       = local.subnetwork != null ? local.subnetwork.id : ""
  description = "Subnetwork ID of the GKE cluster. Empty if external subnetwork provided."
}

output "gke_subnetwork_name" {
  value       = local.subnetwork != null ? local.subnetwork.name : ""
  description = "Subnetwork name of the GKE cluster. Empty if external subnetwork provided."
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
  value       = module.network.mqtt_v4_address
  description = "The IPv4 address of the MQTT service. It is empty if 'enable_external_workers' is set to false."
}

output "mqtt_ipv6_address" {
  value       = module.network.mqtt_v6_address
  description = "The IPv6 address of the MQTT service. It is empty if 'enable_external_workers' is set to false."
}

### Artifact store ###

output "artifact_repository_url" {
  value       = module.artifacts.repository_url
  description = "URL of the Docker repository"
}

### Database ###
output "db_instance_name" {
  value       = var.enable_database ? module.db[0].instance_name : ""
  description = "Name of the database instance"
}

output "db_connection_name" {
  value       = var.enable_database ? module.db[0].database_connection_name : ""
  description = "Connection name of the database cluster. Needs to be passed to the Cloud SQL sidecar proxy See https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine#proxy"
}

output "db_private_ip_address" {
  value       = var.enable_database ? module.db[0].database_private_ip_address : ""
  description = "Private IP address of the database instance."
}

output "db_database_name" {
  value       = var.enable_database ? module.db[0].database_name : ""
  description = "Internal PostgreSQL db name inside the Cloud SQL instance."
}

output "db_root_password" {
  value       = var.enable_database ? module.db[0].database_root_password : ""
  description = "The database root password"
  sensitive   = true
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
  value = templatefile("${path.module}/env.tftpl", {
    env : {
      SPACELIFT_VERSION : var.spacelift_version != null ? var.spacelift_version : "",
      GCP_PROJECT : var.project,
      GCP_LOCATION : var.region,
      K8S_NAMESPACE : var.k8s_namespace,

      # Network
      PUBLIC_IP_ADDRESS : module.network.gke_public_v4_address,
      PUBLIC_IPV6_ADDRESS : module.network.gke_public_v6_address,
      MQTT_IP_ADDRESS : module.network.mqtt_v4_address,
      MQTT_IPV6_ADDRESS : module.network.mqtt_v6_address,

      # Artifacts
      ARTIFACT_REGISTRY_DOMAIN : module.artifacts.repository_domain,
      BACKEND_IMAGE : "${module.artifacts.repository_url}/spacelift-backend",
      LAUNCHER_IMAGE : "${module.artifacts.launcher_repository_url}/spacelift-launcher"

      # Database
      DATABASE_NAME    = var.enable_database ? module.db[0].database_name : ""
      DATABASE_USER    = var.enable_database ? module.db[0].database_iam_user : ""
      DB_ROOT_PASSWORD = var.enable_database ? module.db[0].database_root_password : ""

      #GKE
      GKE_CLUSTER_NAME = module.gke.gke_cluster_name
    },
  })
}

output "kubernetes_secrets" {
  sensitive   = true
  description = "Kubernetes secrets required for the Spacelift services. This output is just included as a convenience for use as part of the EKS getting started guide."
  value = templatefile("${path.module}/kubernetes-secrets.tftpl", {
    NAMESPACE                                      = var.k8s_namespace
    SERVER_DOMAIN                                  = var.website_domain
    MQTT_BROKER_DOMAIN                             = module.dns.mqtt_endpoint
    GCP_PROJECT                                    = var.project,
    OBJECT_STORAGE_BUCKET_DELIVERIES               = module.storage.deliveries_bucket
    OBJECT_STORAGE_BUCKET_LARGE_QUEUE_MESSAGES     = module.storage.large_queue_messages_bucket
    OBJECT_STORAGE_BUCKET_MODULES                  = module.storage.modules_bucket
    OBJECT_STORAGE_BUCKET_POLICY_INPUTS            = module.storage.policy_inputs_bucket
    OBJECT_STORAGE_BUCKET_RUN_LOGS                 = module.storage.run_logs_bucket
    OBJECT_STORAGE_BUCKET_STATES                   = module.storage.states_bucket
    OBJECT_STORAGE_BUCKET_USER_UPLOADED_WORKSPACES = module.storage.user_uploaded_workspaces_bucket
    OBJECT_STORAGE_BUCKET_WORKSPACE                = module.storage.workspace_bucket
    OBJECT_STORAGE_BUCKET_METADATA                 = module.storage.metadata_bucket
    OBJECT_STORAGE_BUCKET_UPLOADS                  = module.storage.uploads_bucket
    DATABASE_URL                                   = var.enable_database ? "postgres://${module.db[0].database_iam_user}@127.0.0.1/${module.db[0].database_name}" : ""
    DATABASE_READ_ONLY_URL                         = var.enable_database ? "postgres://${module.db[0].database_iam_user}@127.0.0.1/${module.db[0].database_name}" : ""
    LICENSE_TOKEN                                  = var.license_token != null ? var.license_token : ""
    ENCRYPTION_RSA_PRIVATE_KEY                     = var.encryption_rsa_private_key
    SPACELIFT_PUBLIC_API                           = var.spacelift_public_api != null ? var.spacelift_public_api : ""
    WEBHOOKS_ENDPOINT                              = "https://${var.website_domain}/webhooks"
    ADMIN_USERNAME                                 = var.admin_username != null ? var.admin_username : ""
    ADMIN_PASSWORD                                 = var.admin_password != null ? var.admin_password : ""
    LAUNCHER_IMAGE                                 = "${module.artifacts.launcher_repository_url}/spacelift-launcher"
    LAUNCHER_IMAGE_TAG                             = var.spacelift_version != null ? var.spacelift_version : ""
  })
}

output "helm_values" {
  description = "Generates a Helm values.yaml file that can be used when deploying Spacelift. This output is just included as a convenience for use as part of the EKS getting started guide."
  value = templatefile("${path.module}/helm-values.tftpl", {
    SERVER_DOMAIN               = var.website_domain
    BACKEND_IMAGE               = "${module.artifacts.repository_url}/spacelift-backend"
    SPACELIFT_VERSION           = var.spacelift_version != null ? var.spacelift_version : ""
    SERVER_SERVICE_ACCOUNT_NAME = module.iam.backend_service_account_email
    DATABASE_CONNECTION_NAME    = var.enable_database ? module.db[0].database_connection_name : ""
    PUBLIC_IP_NAME              = module.network.gke_public_v4_name
    PUBLIC_IPV6_NAME            = module.network.gke_public_v6_name
    EXTERNAL_WORKERS_ENABLED    = var.enable_external_workers
    MQTT_IP_NAME                = module.network.mqtt_v4_name
    MQTT_IPV6_NAME              = module.network.mqtt_v6_name
  })
}
