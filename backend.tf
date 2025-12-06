terraform {
  required_version = "~>1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "~>0.15"
    }
  }

  backend "gcs" {
    bucket = "my-projects-306716-terraform-backend"
    prefix = "core"
  }
}
