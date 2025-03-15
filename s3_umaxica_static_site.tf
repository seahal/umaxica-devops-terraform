resource "aws_s3_bucket" "umaxica_static_page" {
  bucket = "umaxica.cloudfront.staticsite"

  tags = {
    Environment = "Production"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}
