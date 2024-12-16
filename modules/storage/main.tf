locals {
  bucket_names = {
    "large-queue" : "spacelift-large-queue-messages-${var.seed}",
    "metadata" : "spacelift-metadata-${var.seed}",
    "modules" : "spacelift-modules-${var.seed}",
    "policy" : "spacelift-policy-inputs-${var.seed}",
    "run-logs" : "spacelift-run-logs-${var.seed}",
    "states" : "spacelift-states-${var.seed}",
    "uploads" : "spacelift-uploads-${var.seed}",
    "user-uploads" : "spacelift-user-uploaded-workspaces-${var.seed}",
    "workspace" : "spacelift-workspace-${var.seed}",
    "deliveries" : "spacelift-deliveries-${var.seed}",
  }
}

resource "google_storage_bucket" "spacelift-large-queue-messages" {
  name     = local.bucket_names["large-queue"]
  location = var.region
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "spacelift-policy-inputs" {
  name     = local.bucket_names["policy"]
  location = var.region
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

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
  force_destroy = true

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
