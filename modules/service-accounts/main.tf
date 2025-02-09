locals {
  default_cloud_run_sa_roles = toset([])
  terraform_sa_roles = toset([
    "editor",
    "iam.serviceAccountAdmin",
    "iam.workloadIdentityPoolAdmin",
    "run.admin",
    "secretmanager.admin",
  ])
}

data "google_project" "project" {}

resource "google_service_account" "cloud_run_default" {
  account_id   = "cloud-run-default"
  display_name = "Cloud Run Default Service Account"
}

resource "google_project_iam_member" "cloud_run_sa_roles" {
  for_each = local.default_cloud_run_sa_roles

  project = data.google_project.project.project_id
  member  = "serviceAccount:${google_service_account.cloud_run_default.email}"
  role    = "roles/${each.value}"
}

resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform Service Account"
}

resource "google_project_iam_member" "terraform_sa_roles" {
  for_each = local.terraform_sa_roles

  project = data.google_project.project.project_id
  member  = "serviceAccount:${google_service_account.terraform.email}"
  role    = "roles/${each.value}"
}
