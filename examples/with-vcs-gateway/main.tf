terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  region  = var.region
  project = var.project

  default_labels = {
    "environment" = "tf-module-testing"
  }
}

module "spacelift" {
  source = "../.."

  region                       = var.region
  project                      = var.project
  website_domain               = var.server_domain
  database_tier                = "db-f1-micro"
  database_deletion_protection = false
  database_version             = "POSTGRES_17"

  # VCS Gateway configuration
  vcs_gateway_domain = var.vcs_gateway_domain
}

output "vcs_gateway_healthcheck_manifest" {
  value = module.spacelift.vcs_gateway_healthcheck_manifest
}
