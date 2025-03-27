# variables.tf
variable "environments" {
  default = ["production", "staging"]
}

variable "domains" {
  default = ["com", "net", "app", "org"]
}

variable "regions" {
  default = ["jp", "root"]
}

variable "subdomains" {
  default = ["www", "api"]
}

variable "entities" {
  default = ["public", "maintenance", "errors", "functions"]
}

# main.tf
locals {
  # バケット名の組み合わせを生成
  bucket_combinations = flatten([
    for env in var.environments : [
      for entity in var.domains : [
        for subdomain in var.regions : [
          for region in var.subdomains : [
            for domain in var.entities : {
              env       = env
              entity    = entity
              subdomain = subdomain
              region    = region
              domain    = domain
              bucket_name = "umaxica.${env}.cloudfront.${entity}.${subdomain}.${region}.${domain}"
            }
          ]
        ]
      ]
    ]
  ])
}

# define s3 resource 
resource "aws_s3_bucket" "buckets" {
  for_each = { for combo in local.bucket_combinations : combo.bucket_name => combo }

  bucket = each.value.bucket_name
  tags = {
    Environment = each.value.env
    Entity      = each.value.entity
    Subdomain   = each.value.subdomain
    Region      = each.value.region
    Domain      = each.value.domain
  }

  lifecycle {
    prevent_destroy = true
  }
}
# versioning
resource "aws_s3_bucket_versioning" "buckets_versioning" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

# combination of access logs
locals {
  access_log_combinations = flatten([
    for env in var.environments : [
      for region in var.regions : {
        env         = env
        region      = region
        bucket_name = "umaxica.${env}.log.access.${region}"
      }
    ]
  ])
}

# s3 buckts for access log
resource "aws_s3_bucket" "access_log_buckets" {
  for_each = { for combo in local.access_log_combinations : combo.bucket_name => combo }

  bucket = each.value.bucket_name
  tags = {
    Environment = each.value.env
    Region      = each.value.region
  }

  lifecycle {
    prevent_destroy = true
  }
}
# versioning
resource "aws_s3_bucket_versioning" "access_log_buckets_versioning" {
  for_each = aws_s3_bucket.access_log_buckets

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}