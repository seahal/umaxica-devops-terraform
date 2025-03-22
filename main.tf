

# resource "aws_s3_bucket" "example" {
#   bucket = "umaxica.app"
# }

# resource "aws_s3_bucket" "cloudfront_functions" {
#   bucket = "umaxica.cloudfront.functions"

#   tags = {
#     Name        = "snipets for cloudfront functions"
#     Environment = "Production"
#   }
# }

# module "key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "~> 2.0"

#   key_name_prefix    = var.name_prefix
#   create_private_key = true

#   tags = local.tags
# }

resource "aws_s3_bucket" "s3_bucket_of_jp_cloudfront_functions" {
  bucket = "${var.environment}.cff.jp.net.umaxica"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "s3_bucket_of_jp_cloudfront_functions" {
  bucket = aws_s3_bucket.s3_bucket_of_jp_cloudfront_functions.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "asset_files_of_jp_jit_server" {
  bucket = "${var.environment}.asset.jp.net.umaxica"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "asset_files_of_jp_jit_server_versioning" {
  bucket = aws_s3_bucket.asset_files_of_jp_jit_server.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "access_log_all_files" {
  bucket = "${var.environment}.log.all.umaxica"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "access_log_all_files_versioning" {
  bucket = aws_s3_bucket.access_log_all_files.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "access_log_jp_files" {
  bucket = "${var.environment}.log.jp.umaxica"
  tags = {
    Environment = var.environment
  }
}
resource "aws_s3_bucket_versioning" "access_log_jp_files_versioning" {
  bucket = aws_s3_bucket.access_log_jp_files.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "static_page_jp_bucket" {
  bucket = "staticpage.jp.staging.umaxica"
  tags = {
    Environment = var.environment
  }
}
resource "aws_s3_bucket_versioning" "static_page_jp_files_versioning" {
  bucket = aws_s3_bucket.static_page_jp_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.static_page_jp_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}