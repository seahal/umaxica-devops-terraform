
resource "aws_s3_bucket" "access_log" {
  bucket = "umaxica.access.log"

  tags = {
    Environment = "Production"
  }
}
