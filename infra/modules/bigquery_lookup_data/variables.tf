variable "gcs_bucket" {
  description = "The storage bucket where data is stored"
  type        = string   
}

variable "location" {
  description = "The GCP location"
  type        = string
  default     = "europe-west4" 
}

variable "lookup_data" {
  description  = "Map of configuration for data upload"
  type = list(object({
    dataset_name        = string 
    table_name          = string 
    table_description   = string 
    deletion_protection = string #Terraform deletion protection
    
    #The local directory contianing source data to upload
    # The relative path passed here will be used as the object name 
    source_path          = string 
    local_path_prefix    = string #Any prefix for finding the local path, not to be used as the obejct name - e.g. ./environemnt/dev
    
    }))
}