#initialization of variables

variable project_id {
  description = "Bucket project id."
  type        = string
}
variable env {}
variable region { default = "europe-west2" }
variable zone { default = "europe-west2-a" }

variable user_emails {
  default = []
  type    = set(string)
}
variable bucket_configs {
  type = map(object({
    autoclass     = bool
    storage_class = string
  }))
  default = {}
}

variable uniform_bucket_level_access {
  description = "Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API)."
  type        = bool
  default     = true
}

variable location {
  type = string
  default = "europe-west4"
}

