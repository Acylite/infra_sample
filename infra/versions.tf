terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 1.5.7"
  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}

provider "google-beta" {
  project = var.project_id
  region = var.region
  zone = var.zone
}



/*
these are the providers used for terraform. it includes google google-beta (the newest and latest google apis less stable tho) and terraform version
*/
