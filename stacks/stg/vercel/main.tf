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

resource "vercel_project" "umaxica_apps_edge_dev_apex" {
  name           = "umaxica-apps-edge-dev-apex"
  framework      = "vite"
  root_directory = "dev/apex"

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

resource "vercel_project_domain" "umaxica_apps_edge_dev_apex_root" {
  domain     = "umaxica.dev"
  project_id = vercel_project.umaxica_apps_edge_dev_apex.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "vercel_project_environment_variable" "umaxica_apps_edge_dev_apex_dev_core_url" {
  key        = "DEV_CORE_URL"
  project_id = vercel_project.umaxica_apps_edge_dev_apex.id
  target     = ["production", "preview", "development"]
  value      = var.dev_apex_dev_core_url

  lifecycle {
    prevent_destroy = true
  }
}
