resource "aws_s3_bucket" "static_page_jp_bucket" {
  bucket = "staticpage.jp.production.umaxica"
  tags = {
    Environment = var.production.environment
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