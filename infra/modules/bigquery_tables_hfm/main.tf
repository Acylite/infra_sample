resource google_bigquery_table oracle_tables { 
  table_id                    = "dl_reports_data_extracts_${var.scenario}"
  dataset_id                  = var.dataset_name
  description                 = "staging bucket where raw data fro oracle is ingested"
  schema                      = file("${path.module}${var.schema_path}")
  deletion_protection         = false   
  time_partitioning {
    type  = "DAY"
    field = "timestamp"
  }
}