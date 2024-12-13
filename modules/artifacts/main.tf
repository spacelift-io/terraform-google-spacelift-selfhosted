resource "google_artifact_registry_repository" "spacelift" {
  repository_id = "spacelift"
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
