locals {
  project        = "my-projects-306716"
  default_region = "asia-east1"
}

data "infisical_secrets" "env" {
  env_slug     = "prod"
  workspace_id = var.infisical_workspace_id
  folder_path  = "/"
}

module "apis" {
  source = "./modules/cloud-platform"
}

module "service_accounts" {
  source = "./modules/service-accounts"
}

module "github_actions_workload_identity_pool" {
  source = "./modules/workload-identity-pool"

  github_repo_owner_id = data.infisical_secrets.env.secrets["GITHUB_REPO_OWNER_ID"].value
  terraform_sa_id      = module.service_accounts.terraform_sa_id
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  region = local.default_region
}

module "cloud_storage" {
  source = "./modules/cloud-storage"
}
