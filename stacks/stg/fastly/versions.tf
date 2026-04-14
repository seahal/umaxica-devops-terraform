terraform {
  required_version = ">= 1.9.0"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "~> 9.1.0"
    }
  }
}
