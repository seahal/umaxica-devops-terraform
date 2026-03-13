# app jp
resource "google_storage_bucket" "static_app_jp" {
  name                        = "umaxica-staging-gc-storage-perm-app-jp"
  location                    = "asia-northeast1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

# app us
resource "google_storage_bucket" "static_app_us" {
  name                        = "umaxica-staging-gc-sitorage-perm-app-us"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

# com jp
resource "google_storage_bucket" "static_com_jp" {
  name                        = "umaxica-staging-gc-storage-perm-com-jp"
  location                    = "asia-northeast1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

# com us
resource "google_storage_bucket" "static_com_us" {
  name                        = "umaxica-staging-gc-storage-perm-com-us"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

# org jp
resource "google_storage_bucket" "static_org_jp" {
  name                        = "umaxica-staging-gc-storage-perm-org-jp"
  location                    = "asia-northeast1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

# org us
resource "google_storage_bucket" "static_org_us" {
  name                        = "umaxica-staging-gc-storage-perm-org-us"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
