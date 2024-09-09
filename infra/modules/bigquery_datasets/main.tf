resource google_bigquery_dataset create_datasets {
  dataset_id  = var.dataset_name
  location    = "europe-west4"
}