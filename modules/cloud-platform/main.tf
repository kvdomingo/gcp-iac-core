locals {
  apis = toset([
    "artifactregistry",
    "bigquery",
    "cloudbuild",
    "cloudfunctions",
    "cloudresourcemanager",
    "cloudscheduler",
    "compute",
    "datastore",
    "dns",
    "domains",
    "firestore",
    "iam",
    "iamcredentials",
    "iap",
    "logging",
    "monitoring",
    "run",
    "secretmanager",
    "sqladmin",
    "storage",
    "vpcaccess",
  ])
}

resource "google_project_service" "default" {
  for_each = local.apis

  service                    = "${each.value}.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}
