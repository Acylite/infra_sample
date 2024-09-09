#creates the service acocunt

locals {
  iam_pairs = flatten([
    for entity, roles in var.iam : [
      for role in roles : [
        { entity = entity, role = role }
      ]
    ]
  ])
}
resource "google_service_account" "service_account" {
  account_id   = var.service_account
  display_name = "tf managed service Account"
  project      = var.project
}
#binds the policies and roles

resource "google_project_iam_member" "service_account_iam" {
    for_each = toset(var.roles)
    project = var.project
    role = each.value
    member = "serviceAccount:${var.service_account}@${var.project}.iam.gserviceaccount.com"
    depends_on = [google_service_account.service_account]
}
