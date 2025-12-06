provider "google" {
  project = local.project
  region  = local.default_region
}

provider "infisical" {
  host = "https://infisical.lab.kvd.studio"
  auth = {
    token = var.infisical_service_token
  }
}
