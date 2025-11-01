terraform {
  required_version = ">= 1.11.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    fastly = {
      source  = "fastly/fastly"
      version = "5.17.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.24.0"
    }
  }
}