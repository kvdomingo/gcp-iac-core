resource "google_storage_bucket" "dvc" {
  name                        = "kvdstudio-dvc"
  location                    = "ASIA"
  force_destroy               = false
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  soft_delete_policy {
    retention_duration_seconds = 0
  }

  custom_placement_config {
    data_locations = ["asia-east1", "asia-southeast1"]
  }
}
