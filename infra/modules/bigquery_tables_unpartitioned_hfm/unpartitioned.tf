resource google_bigquery_table oracle_unpartitioned_tables { 
  table_id                    = "${var.scenario}"
  dataset_id                  = var.dataset_name
  description                 = "staging bucket where raw data fro oracle is ingested"
  schema                      = file("${path.module}${var.schema_path}")
  deletion_protection         = false  
}