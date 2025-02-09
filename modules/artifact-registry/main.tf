resource "google_artifact_registry_repository" "default" {
  repository_id = "kvdstudio"
  location      = var.region
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }

  vulnerability_scanning_config {
    enablement_config = "DISABLED"
  }
}

resource "google_artifact_registry_repository" "ghcr" {
  repository_id          = "ghcr"
  location               = var.region
  format                 = "DOCKER"
  mode                   = "REMOTE_REPOSITORY"
  cleanup_policy_dry_run = true

  labels = {}

  remote_repository_config {
    disable_upstream_validation = true

    docker_repository {
      custom_repository {
        uri = "https://ghcr.io"
      }
    }
  }

  vulnerability_scanning_config {
    enablement_config = "DISABLED"
  }
}
