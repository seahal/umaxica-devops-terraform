provider "google" {
  project = var.gcp_project
  region  = var.region
}

provider "aws" {
  region = var.region
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = var.kube_ca
  token                  = var.kube_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "fastly" {
  api_key = var.fastly_api_key
}

provider "vercel" {
  api_token = var.vercel_api_token
}

