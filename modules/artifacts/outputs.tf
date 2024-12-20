locals {
  repository_domain     = "${google_artifact_registry_repository.spacelift.location}-docker.pkg.dev"
  repository_url        = "${local.repository_domain}/${google_artifact_registry_repository.spacelift.project}/${google_artifact_registry_repository.spacelift.repository_id}"
  public_repository_url = var.enable_external_workers ? "${local.repository_domain}/${google_artifact_registry_repository.spacelift-public[0].project}/${google_artifact_registry_repository.spacelift-public[0].repository_id}" : local.repository_url
}

output "repository_domain" {
  value       = local.repository_domain
  description = "The domain of the Docker repository"
}

output "repository_url" {
  value       = local.repository_url
  description = "The URL of the Docker repository"
}

output "launcher_repository_url" {
  value       = local.public_repository_url
  description = "The URL of the public Docker repository"
}
