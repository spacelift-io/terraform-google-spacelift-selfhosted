terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
