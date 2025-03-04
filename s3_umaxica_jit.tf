resource "aws_s3_bucket" "umaxica_jit" {
  bucket = "umaxica.cloudfront.jit"
  tags = {
    Environment = "Production"
  }

}
