output "repository_url" {
  value       = "${google_artifact_registry_repository.spacelift.location}-docker.pkg.dev/${google_artifact_registry_repository.spacelift.project}/${google_artifact_registry_repository.spacelift.repository_id}"
  description = "The URL of the Docker repository"
}
