# Temporary test case for ER-10, dropped before the PR is ready.
# Applies the module with create_container_registry = false; the after_apply hook
# checks that the outputs have no image settings.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "region" {
  description = "Identifier of the GCP region to deploy the infrasturcure into."
}

variable "project" {
  description = "Identifier of the GCP project to deploy the infrastructure into."
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
  website_domain               = "spacelift.mycorp.com"
  database_tier                = "db-f1-micro"
  database_deletion_protection = false
  database_version             = "POSTGRES_17"
  enable_external_workers      = true
  spacelift_version            = "v0.0.0-test"

  create_container_registry = false
}

output "artifact_repository_url" {
  value = module.spacelift.artifact_repository_url
}

output "helm_values" {
  value = module.spacelift.helm_values
}

output "shell" {
  value     = module.spacelift.shell
  sensitive = true
}

output "kubernetes_secrets" {
  value     = module.spacelift.kubernetes_secrets
  sensitive = true
}
