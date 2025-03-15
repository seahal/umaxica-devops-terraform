
resource "aws_s3_bucket" "access_log" {
  bucket = "umaxica.access.log"

  tags = {
    Environment = "Production"
  }


  versioning {
    enabled    = true
    mfa_delete = false
  }
}
