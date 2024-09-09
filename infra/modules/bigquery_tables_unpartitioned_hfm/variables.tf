#initialization of variables

variable project_id {
  description = "Bucket project id."
  type        = string
}

variable dataset_name {
  type        = string
}

variable env {}
variable region { default = "europe-west2" }
variable zone { default = "europe-west2-a" }

variable bq_unpartitioned {
  type = map(object({
    dataset_id           = string
    schema_path          = string
    scenario                = string
  }))
  default = {}
}

variable schema_path {
  type        = string
}
variable scenario  {
  type        = string
}

      