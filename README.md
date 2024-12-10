# Terraform module for Spacelift on Google Cloud Platform

This module creates a base infrastructure for a self-hosted Spacelift instance on Google Cloud Platform.

## Usage

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted?ref=v0.0.1"

  region         = "europe-west1"
  project        = "spacelift-production"
  license_token  = "<token issued by Spacelift>"
  website_domain = "https://mycompany.spacelift.com"
}
```

The module creates:

- IAM resources
  - IAM service account for the GKE cluster
  - IAM service account for the Spacelift backend service, meant to be used by the Spacelift backend
- Network resources
  - a network for the infrastructure
  - a subnetwork for the GKE cluster
- Artifact repository
  - a Google Artifact Registry repository for storing Docker images
- Database resources
  - a Postgres Cloud SQL instance
- Secret Manager resources
  - a secret for the root password of the Cloud SQL instance. Note that isn't important for Spacelift as it uses passwordless IAM authentication.
  - a secret for the license token. It can be used to inject the license token into the Spacelift backend service.
- Storage resources
  - buckets for storing various data

## Inputs

| Name                            | Description                                                                                                                                                                                                                                            | Type   | Default               | Required |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | --------------------- | -------- |
| region                          | The region in which the resources will be created.                                                                                                                                                                                                     | string | -                     | yes      |
| project                         | The ID of the project in which the resources will be created.                                                                                                                                                                                          | string | -                     | yes      |
| license_token                   | The license token issued by Spacelift.                                                                                                                                                                                                                 | string | -                     | yes      |
| website_domain                  | The domain under which the Spacelift instance will be hosted. This is used for the CORS rules of one of the buckets.                                                                                                                                   | string | -                     | yes      |
| database_edition                | Edition of the Cloud SQL instance. Can be either ENTERPRISE or ENTERPRISE_PLUS.                                                                                                                                                                        | string | ENTERPRISE            | no       |
| database_tier                   | The tier of the Cloud SQL instance.                                                                                                                                                                                                                    | string | db-perf-optimized-N-4 | no       |
| create_compute_address_for_mqtt | Whether to create a compute address for MQTT. It is meant to be used by Service of type LoadBalancer from the GKE cluster to expose the embedded MQTT server to the world. This is only required if you want to run worker outside of the GKE cluster. | bool   | false                 | no       |
| ip_cidr_range                   | The IP CIDR range for the subnetwork used by the GKE cluster                                                                                                                                                                                           | string | 10.0.0.0/16           | no       |
| secondary_ip_range_for_services | The secondary IP range for the subnetwork used by the GKE cluster. This range is used for services                                                                                                                                                     | string | 192.168.16.0/22       | no       |
| secondary_ip_range_for_pods     | The secondary IP range for the subnetwork used by the GKE cluster. This range is used for pods                                                                                                                                                         | string | 192.168.0.0/20        | no       |

## Outputs

| Name                            | Description                                                                                                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| region                          | The region in which the resources were created.                                                                                                              |
| project                         | The ID of the project in which the resources were created.                                                                                                   |
| gke_service_account_email       | The email of the service account used by the GKE cluster.                                                                                                    |
| backend_service_account_email   | The email of the service account meant to be used by the Spacelift backend service.                                                                          |
| network_id                      | ID of the network the Spacelift infrastructure is deployed in.                                                                                               |
| network_name                    | Name of the network the Spacelift infrastructure is deployed in.                                                                                             |
| network_link                    | Self-link of the network the Spacelift infrastructure is deployed in.                                                                                        |
| gke_subnetwork_id               | ID of the subnetwork the GKE cluster is deployed in.                                                                                                         |
| gke_subnetwork_name             | Name of the subnetwork the GKE cluster is deployed in.                                                                                                       |
| gke_cluster_name                | Name of the GKE cluster.                                                                                                                                     |
| gke_public_v4_address           | Public IPv4 address of the GKE cluster.                                                                                                                      |
| gke_public_v6_address           | Public IPv6 address of the GKE cluster.                                                                                                                      |
| mqtt_ipv4_address               | IPv4 address of the MQTT service. It's null if create_compute_address_for_mqtt is false. It's only useful in case the workerpool is outside the GKE cluster. |
| mqtt_ipv6_address               | IPv6 address of the MQTT service. It's null if create_compute_address_for_mqtt is false. It's only useful in case the workerpool is outside the GKE cluster. |
| artifact_repository_url         | URL of the Docker artifact repository.                                                                                                                       |
| db_cluster_name                 | Name of the Cloud SQL instance.                                                                                                                              |
| db_connection_string            | Connection string for the Cloud SQL instance. Note that it doesn't contain a secret as it's using IAM authentication.                                        |
| db_root_password_secret_id      | Secret ID of the root password for the Cloud SQL instance.                                                                                                   |
| large_queue_messages_bucket     | Name of the bucket used for storing large queue messages.                                                                                                    |
| metadata_bucket                 | Name of the bucket used for storing run metadata.                                                                                                            |
| modules_bucket                  | Name of the bucket used for storing Spacelift modules.                                                                                                       |
| policy_inputs_bucket            | Name of the bucket used for storing policy inputs.                                                                                                           |
| run_logs_bucket                 | Name of the bucket used for storing run logs.                                                                                                                |
| states_bucket                   | Name of the bucket used for storing stack states.                                                                                                            |
| uploads_bucket                  | Name of the bucket used for storing user uploads.                                                                                                            |
| user_uploaded_workspaces_bucket | Name of the bucket used for storing user uploaded workspaces. This is used for the local preview feature.                                                    |
| workspace_bucket                | Name of the bucket used for storing stack workspace data.                                                                                                    |
| deliveries_bucket               | Name of the bucket used for storing audit trail delivery data.                                                                                               |

