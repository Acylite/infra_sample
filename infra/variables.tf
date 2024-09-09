#initialization of variables

variable project_id {
  description = "tf project id."
  type        = string
}

variable env {}
variable region { default = "europe-west2" }
variable zone { default = "europe-west2-a" }
variable bucket_configs {
  type = map(object({
    autoclass     = bool
    storage_class = string
  }))
  default = {}
}

variable bq_configs {
  type = map(object({
    dataset_id           = string
    schema_path          = string
    scenario              = string
  }))
  default = {}
}


variable bq_unpartitioned {
  type = map(object({
    dataset_id           = string
    schema_path          = string
    scenario             = string
  }))
  default = {}
}

variable metadata_schema_path {
  type = string
}
variable table_configs {
  type = list(object({ 
    dataset_id    = string
    table_name    = string
    schema_path   = string
  }))
}

variable user_emails {
  default = []
  type    = set(string)
}

variable location {
  type = string
  default = "europe-west4"
}

variable roles {
  type = list(string)
}
variable write_roles {
  type = list(string)
}

variable uniform_bucket_level_access {
  description = "Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API)."
  type        = bool
  default     = true
}

variable apis {
  default = []
  type    = set(string)
}
variable subnet_cidr {}
variable vpc_name {}
variable subnet_name {}
variable datasets {
  default = []
  type = list(string)
}

variable composer_service_account {}

variable write_service_account {}

variable lookup_data {}

variable lookup_data_bucket {}
