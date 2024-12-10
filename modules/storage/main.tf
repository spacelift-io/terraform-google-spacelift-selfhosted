resource "random_id" "unique-bucket-suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "spacelift-large-queue-messages" {
  name     = "spacelift-large-queue-messages-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-metadata-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-modules-${random_id.unique-bucket-suffix.hex}"
  location = var.region

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "spacelift-policy-inputs" {
  name     = "spacelift-policy-inputs-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-run-logs-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-states-${random_id.unique-bucket-suffix.hex}"
  location = var.region
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
  name     = "spacelift-uploads-${random_id.unique-bucket-suffix.hex}"
  location = var.region

  public_access_prevention = "enforced"

  cors {
    origin = var.cors_origins
    method = ["PUT", "POST"]
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
  name     = "spacelift-user-uploaded-workspaces-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-workspace-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
  name     = "spacelift-deliveries-${random_id.unique-bucket-suffix.hex}"
  location = var.region

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
