terraform {
  required_version = "~>1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6"
    }
  }

  backend "gcs" {
    bucket = "my-projects-306716-terraform-backend"
    prefix = "core"
  }
}
