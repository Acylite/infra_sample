/* Module to create an external BigQuery table on top of a csv file */
locals {
  upload_objects = toset(flatten([ for table in var.lookup_data : [
        for filename in fileset(table.source_path, "**") : {
           object_name = "${trimprefix(table.source_path, table.local_path_prefix)}/${filename}"
           filepath   =  "${table.source_path}/${filename}" 
        }
      ]
  ]))
}

resource "google_storage_bucket" "lookup_data" {
  name   = var.gcs_bucket
  location = var.location
  uniform_bucket_level_access = true
} 

resource "google_storage_bucket_object" "fx_lookup_data" {
  for_each = {for file in local.upload_objects : file.object_name => file }
  name   = each.value.object_name
  source = each.value.filepath 
  bucket = google_storage_bucket.lookup_data.name
 
  depends_on = [google_storage_bucket.lookup_data]
}
resource "google_bigquery_table" "lookup_fx_table" {
  for_each = { for index, table in var.lookup_data : "${table.dataset_name}-${table.table_name}" => table }
  table_id                    = each.value.table_name 
  dataset_id                  = each.value.dataset_name
  description                 = each.value.table_description
  deletion_protection         = each.value.deletion_protection
  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
    csv_options {
      quote           = ""
    }
    source_uris   = ["${google_storage_bucket.lookup_data.url}/${trimprefix(each.value.source_path, each.value.local_path_prefix)}/*"]
  }
  depends_on = [google_storage_bucket_object.fx_lookup_data]
}
