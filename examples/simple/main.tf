terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
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
}
