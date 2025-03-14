

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
