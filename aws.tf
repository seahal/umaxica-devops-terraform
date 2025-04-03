# variables.tf
variable "environments" {
  default = ["production", "staging"]
}

variable "subdomains" {
  default = ["www", "api"]
}

variable "regions" {
  default = ["jp", "root"]
}

variable "domains" {
  default = ["com", "net", "app", "org"]
}

variable "entities" {
  default = ["public", "maintenance", "errors", "functions"]
}

variable "mimes" {
  default = ["ogp"]
}

variable "layers" {
  default = ["access", "audit", "var"]
}

# main.tf
locals {
  # バケット名の組み合わせを生成
  bucket_combinations = flatten([
    for env in var.environments : [
      for subdomain in var.subdomains : [
        for region in var.regions : [
          for domain in var.domains : [
            for entity in var.entities : {
              env         = env
              entity      = entity
              subdomain   = subdomain
              region      = region
              domain      = domain
              bucket_name = "umaxica.${env}.cloudfront.${subdomain}.${region}.${domain}.${entity}"
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
      for layer in var.layers : [
        for region in var.regions : {
          env         = env
          region      = region
          layer       = layer
          bucket_name = "umaxica.${env}.log.${layer}.${region}"
        }
      ]
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

# combination of aot
locals {
  buckts_of_aot_combinations = flatten([
    for env in var.environments : [
      for region in var.regions : [
        for mime in var.mimes : {
          env         = env
          region      = region
          mime        = mime
          bucket_name = "umaxica.${env}.aot.${region}.app.${mime}"
        }
    ]]
  ])
}
# s3 buckts for access log
resource "aws_s3_bucket" "aot_buckets" {
  for_each = { for combo in local.buckts_of_aot_combinations : combo.bucket_name => combo }

  bucket = each.value.bucket_name
  tags = {
    Environment = each.value.env
    Region      = each.value.region
  }

  lifecycle {
    prevent_destroy = false
  }
}
# versioning
resource "aws_s3_bucket_versioning" "aot_buckets_versioning" {
  for_each = aws_s3_bucket.aot_buckets

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}
