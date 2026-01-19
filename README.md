# ☁️ Terraform module for Spacelift on Google Cloud Platform

This module creates a base infrastructure for a self-hosted Spacelift instance on Google Cloud Platform.

> [!IMPORTANT]
> **Breaking change in v2.0.0:** The database version is now configurable and must be explicitly defined (no longer hardcoded to `POSTGRES_14`). This enables you to upgrade to newer PostgreSQL versions. See the [Terraform resource documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) for available versions.

## State storage

Check out the [Terraform](https://developer.hashicorp.com/terraform/language/backend) or the [OpenTofu](https://opentofu.org/docs/language/settings/backends/configuration/) backend documentation for more information on how to configure the state storage.

> ⚠️ Do **not** import the state into Spacelift after the installation: that would cause circular dependencies, and in case you accidentally break the Spacelift installation, you wouldn't be able to fix it.

## ✨ Usage

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted?ref=v2.0.0"

  region           = "europe-west1"
  project          = "spacelift-production"
  website_domain   = "spacelift.mycompany.com"
  database_version = "POSTGRES_17"
}
```

The module creates:

- IAM resources
  - IAM service account for the GKE cluster
  - IAM service account for the Spacelift backend services, meant to be used by the Spacelift backend
- Network resources
  - a compute network for the infrastructure
  - a compute subnetwork for the GKE cluster
- Artifact repository
  - a Google Artifact Registry repository for storing Docker images
  - a PUBLIC Google Artifact Registry repository for storing Docker images for workers (if external workers are enabled)
- Database resources
  - a Postgres Cloud SQL instance
- Storage resources
  - various buckets for storing run metadata, run logs, workspaces, stack states etc.
- GKE autopilot cluster  
  - a Kubernetes cluster to install Spacelift on

## Module registries

The module is also available [on the OpenTofu registry](https://search.opentofu.org/module/spacelift-io/spacelift-selfhosted/google/latest) where you can browse the input and output variables.

## Examples

### Default

This deploys a new VPC, a new Cloud SQL instance and a GKE cluster

```hcl
module "spacelift" {
  source  = "github.com/spacelift-io/terraform-google-spacelift-selfhosted"

  region           = var.region
  project          = var.project
  website_domain   = var.app_domain
  database_tier    = "db-f1-micro"
  database_version = "POSTGRES_17"
}
```

### Deploy a cluster in an existing network

```hcl
resource "google_compute_network" "default" {
  name = "test"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name    = "test"
  network = google_compute_network.default.id
  region        = var.region
  ip_cidr_range = "10.0.0.0/16"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
  secondary_ip_range {
    range_name = "services"
    ip_cidr_range = "192.168.16.0/22"
  }
  secondary_ip_range {
    range_name = "pods"
    ip_cidr_range = "192.168.0.0/20"
  }
}

module "spacelift" {
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted"

  region           = var.region
  project          = var.project
  website_domain   = var.app_domain
  database_tier    = "db-f1-micro"
  database_version = "POSTGRES_17"

  enable_network = false
  network = google_compute_network.default
  subnetwork = google_compute_subnetwork.default
}
```

### Do not create a VPC and GKE cluster

```hcl
resource "google_compute_network" "default" {
  name = "test"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_service_account" "gke-node-service-account" {
  account_id = "test-elie"
}

module "spacelift" {
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted"

  region           = var.region
  project          = var.project
  website_domain   = var.app_domain
  database_tier    = "db-f1-micro"
  database_version = "POSTGRES_17"

  enable_gke = false
  enable_network = false
  node_service_account = google_service_account.gke-node-service-account
  network = google_compute_network.default
}
```

### Do not create DB, VPC and GKE cluster

```hcl
resource "google_service_account" "gke-node-service-account" {
  account_id = "test-elie"
}

module "spacelift" {
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted"

  region         = var.region
  project        = var.project
  website_domain = var.app_domain

  enable_database      = false
  enable_gke           = false
  enable_network       = false
  node_service_account = google_service_account.gke-node-service-account
}
```

### With VCS Gateway

See the [with-vcs-gateway example](./examples/with-vcs-gateway) for deploying Spacelift with VCS Gateway enabled, bridging Spacelift to internally-hosted VCS systems (e.g., GitHub Enterprise, GitLab, Bitbucket Data Center).

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull request. Once the pull request is merged, the workflow will create a new release.
