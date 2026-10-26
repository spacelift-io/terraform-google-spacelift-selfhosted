# Temporary test case for ER-10, dropped before the PR is ready.
# Applies the released v3.1.0, then the after_apply hook switches the source to
# this branch and checks that the plan has no changes. External workers stay off:
# the CI identity cannot create the Cloud DNS zone they need (403).

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
  source = "github.com/spacelift-io/terraform-google-spacelift-selfhosted?ref=v3.1.0"

  region                       = var.region
  project                      = var.project
  website_domain               = "spacelift.mycorp.com"
  database_tier                = "db-f1-micro"
  database_deletion_protection = false
  database_version             = "POSTGRES_17"
}
