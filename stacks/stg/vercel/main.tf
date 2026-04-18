locals {
  apps_edge_git_repository = {
    production_branch = "main"
    type              = "github"
    repo              = "seahal/umaxica-apps-edge"
  }
}

resource "vercel_project" "umaxica_apps_edge_dev_core" {
  name           = "umaxica-apps-edge-dev-core"
  framework      = "nextjs"
  root_directory = "dev/core"

  oidc_token_config = {
    enabled = true
  }

  vercel_authentication = {
    deployment_type = "standard_protection"
  }

  git_repository = local.apps_edge_git_repository

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [vercel_authentication]
  }
}

import {
  to = vercel_project.umaxica_apps_edge_dev_core
  id = "prj_oAkVGW2hCCyfgtEvGjeFVPvFYndI"
}

resource "vercel_project_domain" "umaxica_apps_edge_dev_core_www" {
  domain     = "www.umaxica.dev"
  project_id = vercel_project.umaxica_apps_edge_dev_core.id

  lifecycle {
    prevent_destroy = true
  }
}
