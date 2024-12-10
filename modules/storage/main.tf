resource "random_id" "unique-bucket-suffix" {
  byte_length = 4
}

locals {
  bucket_names = {
    "large-queue" : "spacelift-large-queue-messages-${random_id.unique-bucket-suffix.hex}",
    "metadata" : "spacelift-metadata-${random_id.unique-bucket-suffix.hex}",
    "modules" : "spacelift-modules-${random_id.unique-bucket-suffix.hex}",
    "policy" : "spacelift-policy-inputs-${random_id.unique-bucket-suffix.hex}",
    "run-logs" : "spacelift-run-logs-${random_id.unique-bucket-suffix.hex}",
    "states" : "spacelift-states-${random_id.unique-bucket-suffix.hex}",
    "uploads" : "spacelift-uploads-${random_id.unique-bucket-suffix.hex}",
    "user-uploads" : "spacelift-user-uploaded-workspaces-${random_id.unique-bucket-suffix.hex}",
    "workspace" : "spacelift-workspace-${random_id.unique-bucket-suffix.hex}",
    "deliveries" : "spacelift-deliveries-${random_id.unique-bucket-suffix.hex}",
  }
}

resource "google_storage_bucket" "spacelift-large-queue-messages" {
  name     = local.bucket_names["large-queue"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "Delete"
    }
  }
  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "spacelift-metadata" {
  name     = local.bucket_names["metadata"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"


  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "Delete"
    }
  }
  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "spacelift-modules" {
  name     = local.bucket_names["modules"]
  location = var.region
  labels   = var.labels

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "spacelift-policy-inputs" {
  name     = local.bucket_names["policy"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "spacelift-run-logs" {
  name     = local.bucket_names["run-logs"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 1
    }
  }

  lifecycle_rule {
    condition {
      age = 60
    }
    action {
      type = "Delete"
    }
  }
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


resource "google_storage_bucket" "spacelift-states" {
  name     = local.bucket_names["states"]
  location = var.region
  labels   = var.labels

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 30
    }
  }

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "spacelift-uploads" {
  name     = local.bucket_names["uploads"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  cors {
    origin          = var.cors_origins
    method          = ["PUT", "POST"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 1
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "spacelift-user-uploaded-workspaces" {
  name     = local.bucket_names["user-uploads"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 1
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


resource "google_storage_bucket" "spacelift-workspace" {
  name     = local.bucket_names["workspace"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 1
    }
  }

  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "spacelift-deliveries" {
  name     = local.bucket_names["deliveries"]
  location = var.region
  labels   = var.labels

  public_access_prevention = "enforced"

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}
