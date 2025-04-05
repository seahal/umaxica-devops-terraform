# variables.tf
variable "environments" {
  default = ["production"]
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
  default = ["ogp", "docs", "news"]
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
              bucket_name = "umaxica.${env}.cloudfront.${region}.${subdomain}.${domain}.${entity}"
            }
          ]
        ]
      ]
    ]
  ])
}



# define s3 resource 
resource "aws_s3_bucket" "cloudfront_buckets" {
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
    prevent_destroy = false
  }
}
# versioning
resource "aws_s3_bucket_versioning" "cloudfront_buckets_versioning" {
  for_each = aws_s3_bucket.cloudfront_buckets
  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "cloudfront_buckets_block" {
  for_each = aws_s3_bucket.cloudfront_buckets
  bucket   = each.value.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_cloudfront_origin_access_control" "cloudfront_buckets_access_controll" {
  for_each = aws_s3_bucket.cloudfront_buckets
  name = each.value.id

  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
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
    prevent_destroy = false
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
resource "aws_s3_bucket_public_access_block" "access_log_buckets_block" {
  for_each = aws_s3_bucket.access_log_buckets
  bucket   = each.value.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_log_buckets_lifecycle" {
  for_each = aws_s3_bucket.access_log_buckets
  bucket =  each.value.id

  rule {
    id = "log"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 365
    }
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
# s3 buckts for aot log
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
resource "aws_s3_bucket_public_access_block" "aot_buckets_block" {
  for_each = aws_s3_bucket.aot_buckets
  bucket   = each.value.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}