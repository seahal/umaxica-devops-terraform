# AWS staging app resources

resource "aws_ecr_repository" "rails_app" {
  name                 = "umaxica-rails-stg"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "rails_app" {
  repository = aws_ecr_repository.rails_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

output "ecr_repository_url" {
  description = "ECR repository URL for Rails app"
  value       = aws_ecr_repository.rails_app.repository_url
}
