location = "europe-west4"
region = "europe-west4"
zone   = "europe-west4-a"
apis = [
  "bigquery",
  "cloudbuild",
  "secretmanager",
  "iap",
  "iam",
  "iamcredentials",
  "cloudkms",
  "cloudfunctions"
]

# Cloud Storage
bucket_configs = {
  "oracle-hfm-raw-data" = {
    autoclass     = true
    storage_class = "STANDARD"
  }
}

bq_configs = {
}
bq_unpartitioned = {
}

metadata_schema_path = "/modules/bigquery_tables_hfm/schemas/oracle.dimension_raw_metadata_schema.json"


table_configs = [
  { 
    dataset_id    = "hierarchy"
    table_name    = "Accounts"
    schema_path   = "/schemas/hierarchy.Accounts.json"
  }
]

datasets = ["oracle", "calc", "oracle_metric", "FX_RATE_TABLE", "hierarchy"]
vpc_name = "netoraclehfm"
subnet_name = "snetoraclehfm"
subnet_cidr = "10.1.0.0/16"

roles = [
  "roles/bigquery.dataEditor",
  "roles/bigquery.jobUser",
  "roles/composer.ServiceAgentV2Ext",
  "roles/composer.worker",
  "roles/dataproc.editor",
  "roles/secretmanager.secretAccessor",
  "roles/iam.serviceAccountUser",
  "roles/bigquery.readSessionUser"
]

write_roles = [
  "roles/iam.workloadIdentityUser",
  "roles/storage.admin",
  "roles/storage.objectUser",
  "roles/storage.objectViewer"
]


composer_service_account = "project-service-account"
write_service_account = "write"
