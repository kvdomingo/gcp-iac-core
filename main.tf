locals {
  project        = "my-projects-306716"
  default_region = "asia-east1"
}

provider "google" {
  project = local.project
  region  = local.default_region
}

provider "hcloud" {
  token = var.hetzner_token
}

module "apis" {
  source = "./modules/cloud-platform"
}

module "service_accounts" {
  source = "./modules/service-accounts"
}

module "github_actions_workload_identity_pool" {
  source = "./modules/workload-identity-pool"

  github_repo_owner_id = var.github_repo_owner_id
  terraform_sa_id      = module.service_accounts.terraform_sa_id
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  region = local.default_region
}

module "hetzner_lab" {
  source = "./modules/hetzner-lab"
}
