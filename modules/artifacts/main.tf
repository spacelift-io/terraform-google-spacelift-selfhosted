resource "google_artifact_registry_repository" "spacelift" {
  repository_id = "spacelift-${var.seed}"
  format        = "DOCKER"
  description   = "This repository contains the images for Spacelift"

  cleanup_policies {
    id     = "keep-10-images"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}

resource "google_artifact_registry_repository" "spacelift-public" {
  count = var.enable_external_workers ? 1 : 0
  repository_id = "spacelift-public-${var.seed}"
  format        = "DOCKER"
  description   = "This repository contains the public images for Spacelift"

  cleanup_policies {
    id     = "keep-10-images"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}

resource "google_artifact_registry_repository_iam_binding" "public" {
  count = var.enable_external_workers ? 1 : 0
  members = ["allUsers"]
  repository = google_artifact_registry_repository.spacelift-public[0].id
  role       = "roles/artifactregistry.reader"
}
