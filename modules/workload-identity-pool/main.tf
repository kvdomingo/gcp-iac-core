data "google_project" "project" {}

resource "google_iam_workload_identity_pool" "github_actions_pool" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-pool-provider"
  display_name                       = "GitHub Actions Pool Provider"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository_id"
    "attribute.repository_owner" = "assertion.repository_owner_id"
  }

  attribute_condition = "attribute.repository_owner == \"${var.github_repo_owner_id}\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "terraform_sa_wif_member" {
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id}/attribute.repository_owner/${var.github_repo_owner_id}"
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = var.terraform_sa_id
}
