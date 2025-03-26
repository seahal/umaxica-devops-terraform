


# Access Log for root layer
resource "aws_s3_bucket" "access_log_production_bucket" {
  bucket = "umaxica.production.log.access"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "access_log_production_bucket_versioning" {
  bucket = aws_s3_bucket.access_log_production_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Access Log for root layer
resource "aws_s3_bucket" "jp_access_log_production_bucket" {
  bucket = "umaxica.production.log.access.jp"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "access_log_jp_files_versioning" {
  bucket = aws_s3_bucket.jp_access_log_production_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# static pages
##  www.umaxica.com
### public
resource "aws_s3_bucket" "umaxica_production_cloudfront_functions_bucket" {
  bucket = "umaxica.production.cloudfront.functions"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "umaxica_production_cloudfront_functions_bucket_versioning" {
  bucket = aws_s3_bucket.umaxica_production_cloudfront_functions_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# static pages
##  www.umaxica.com
### public
resource "aws_s3_bucket" "umaxica_production_static_public_www_com_bucket" {
  bucket = "umaxica.production.static.public.www.com"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "umaxica_production_static_public_www_com_bucket_versioning" {
  bucket = aws_s3_bucket.umaxica_production_static_public_www_com_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
### errors
resource "aws_s3_bucket" "umaxica_production_static_errors_www_com_bucket" {
  bucket = "umaxica.production.static.errors.www.com"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "umaxica_production_static_errors_www_com_bucket_versioning" {
  bucket = aws_s3_bucket.umaxica_production_static_errors_www_com_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
### maitenace
resource "aws_s3_bucket" "umaxica_production_static_maintenace_www_com_bucket" {
  bucket = "umaxica.production.static.maintenance.www.com"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "umaxica_production_static_mainenace_www_com_bucket_versioning" {
  bucket = aws_s3_bucket.umaxica_production_static_maintenace_www_com_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}