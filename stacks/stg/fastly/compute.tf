# Import the existing Fastly Compute service created via the Fastly UI/CLI
# (reasonably-stunning-gecko.edgecompute.app) into the Terraform state.
#
# After `terraform apply` records the import, delete this block.
import {
  to = fastly_service_compute.hono_staging
  id = "0495vxXrSLyzMFuT8hXcmS"
}
