
data google_project project {
  project_id = var.project_id
}

module "iam" {
  source               = "./modules/iam"
  project              = var.project_id
  service_account       = var.composer_service_account
  roles                 = var.roles
}

module "write_iam" {
  source               = "./modules/iam"
  project              = var.project_id
  service_account      = var.write_service_account
  roles                = var.write_roles
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [module.iam]

  create_duration = "30s"
}


# GCS Buckets
module "buckets" {
  for_each = var.bucket_configs
  source                      = "./modules/gcs"
  env                          = var.env
  project_id                  = var.project_id
  depends_on                  = [module.iam]
}
#bigquery datasets
module "bqdatasets" {
  for_each = toset(var.datasets)
  source                        = "./modules/bigquery_datasets"    
  dataset_name                  = each.value
  depends_on                     = [module.iam]
}
#bigquery
module "bqtables" {
  for_each = var.bq_configs
  source                        = "./modules/bigquery_tables_hfm"    
  dataset_name                  = each.value.dataset_id
  project_id                    = var.project_id
  env                           = var.env
  scenario                       = each.value.scenario
  schema_path                   = each.value.schema_path
  depends_on                  = [module.iam, module.bqdatasets]
}

module "bqunpartitionedtables" {
  for_each = var.bq_unpartitioned
  source                        = "./modules/bigquery_tables_unpartitioned_hfm"    
  dataset_name                  = each.value.dataset_id
  project_id                    = var.project_id
  env                           = var.env
  scenario                      = each.value.scenario
  schema_path                   = each.value.schema_path
  depends_on                  = [module.iam, module.bqdatasets]
}

resource google_bigquery_table oracle_table_metadata { 
  table_id                    = "dl_reports_data_metadata_raw"
  dataset_id                  = "oracle_hfm"
  description                 = "staging bigquery table where raw data fro oracle is ingested"
  schema                      = file("${path.module}${var.metadata_schema_path}")  
  deletion_protection         = false   
}


module "vpc" {
  source       = "./modules/vpc"
  vpc_name     = var.vpc_name
  subnet_name  = var.subnet_name
  region       = var.region
  subnet_cidr  = var.subnet_cidr
  depends_on   = [module.iam]
}

module "composer" {
  source                = "./modules/composer"
  project_id            = var.project_id
  network_self_link     = module.vpc.vpc_self_link
  subnetwork_self_link  = module.vpc.subnet_self_link
  service_account_email =  "${var.composer_service_account}@${var.project_id}.iam.gserviceaccount.com"
  env                   = var.env
  depends_on            = [module.iam]
}

module "workload_identity_pool" {
  source               = "./modules/workload_identity_pool"
  project              = var.project_id
  write_roles            = var.write_roles
  write_service_account = var.write_service_account
  depends_on = [module.iam, module.write_iam]
}

module "bigquery_lookup_data" {
  source       = "./modules/bigquery_lookup_data"
  gcs_bucket  = var.lookup_data_bucket 
  lookup_data = var.lookup_data
}
