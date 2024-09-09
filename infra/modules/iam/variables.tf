variable roles {
    type = list(string)
}
variable project {}
variable iam {
  description = "IAM bindings on the service account in {ROLE => [MEMBERS]} format."
  type        = map(list(string))
  default     = {}
  nullable    = false
}
variable service_account {}
