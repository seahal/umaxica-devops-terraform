terraform {
  required_version = ">= 1.10.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    fastly = {
      source  = "fastly/fastly"
      version = "5.17.0"
    }
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.26.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "umaxica.app"
}

resource "aws_s3_bucket" "cloudfront_functions" {
  bucket = "umaxica.cloudfront.functions"

  tags = {
    Name        = "snipets for cloudfront functions"
    Environment = "Production"
  }
}
