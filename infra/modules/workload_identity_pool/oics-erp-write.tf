
# Workload Identity Pool
data google_project project {
}

resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "pool"
}

resource "google_service_account_iam_binding" "write_iam_attach" {
  service_account_id = "projects/${var.project}/serviceAccounts/${var.write_service_account}@${var.project}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  members            = ["principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}/attribute.aud/https://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}-prvdr"]
}

resource "google_iam_workload_identity_pool_provider" "example" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "${google_iam_workload_identity_pool.pool.workload_identity_pool_id}-prvdr"
  display_name                       = "Pool provider"
  description                        = "identity pool provider"
  disabled                           = false
  oidc {
    allowed_audiences = [
      "https://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}-prvdr"
    ]
    issuer_uri = "https://idcs-0a85eae48a7a4ccd981b2013354b1e7f.identity.oraclecloud.com"
  }
  attribute_mapping = {
    "attribute.aud"  = "assertion.aud"
    "google.subject" = "assertion.sub"
  }
  depends_on = [google_iam_workload_identity_pool.pool]
}