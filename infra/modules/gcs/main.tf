locals {
  oracle_hfm_buckets = ["oracle-raw-data"]
  bucket_permissions = flatten(
    [for email in var.user_emails: [
      for bucket in local.oracle_hfm_buckets: {
        bucket = "${var.project_id}-${bucket}"
        role   = "roles/storage.objectViewer"
        member = "user:${email}"
      }
    ]]
  )
}

resource google_storage_bucket oracle_hfm_raw_data {
    name = "${var.project_id}-oracle-raw-data"
    location = var.location
    uniform_bucket_level_access = true
}
