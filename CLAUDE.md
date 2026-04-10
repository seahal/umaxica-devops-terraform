@AGENTS.md

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Umaxica DevOps Terraform — multi-cloud infrastructure for the Umaxica platform. Manages resources across GCP, AWS, Azure, Cloudflare, Fastly, Vercel, and Kubernetes using Terraform (with Terraform Cloud).

## Architecture

- **`modules/`** — reusable Terraform modules
  - `aws-app/` — S3 static site bucket (versioning + website config)
  - `aws-network/` — AWS networking (skeleton)
  - `gcp-cloud-run/` — GCP Cloud Run (skeleton)
- **`stacks/`** — environment + cloud + region directory tree; each leaf is an independent Terraform root
  - `stacks/{stg,prod}/aws/ap-northeast-1/{app,state-backend}/` — AWS resources per environment
  - `stacks/{stg,prod}/gcp/asia-northeast1/identity/` — GCP identity stacks
  - `stacks/{stg,prod}/cloudflare/` and `stacks/{stg,prod}/vercel/` — edge platform stacks
- **Per-stack `.tf` files** — each root owns its own `backend.tf`, `providers.tf`, `versions.tf`, and resource files
- **`files/` / `templates/` / `scripts/`** — helper artifacts (currently placeholder `.keep` files)

## Common Commands

```bash
# Install toolchain (requires asdf)
asdf install terraform 1.9.0 && asdf install tflint latest

# Initialize a stack
terraform -chdir=stacks/stg/aws/ap-northeast-1/app init
terraform -chdir=stacks/prod/aws/ap-northeast-1/app init

# Plan (review before apply)
terraform -chdir=stacks/stg/aws/ap-northeast-1/app plan

# Format and lint
terraform fmt -recursive              # auto-format all .tf files
terraform fmt -check -recursive       # CI format check
terraform validate                    # validate config
tflint --chdir stacks/stg/aws/ap-northeast-1/app  # lint
yamlfmt .                        # format YAML files

# Run pre-commit hooks manually
lefthook run pre-commit
```

## Providers (versions.tf)

Terraform >= 1.9.0. Required providers: google (~> 7.0), aws (~> 5.0), azurerm (~> 3.24.0), kubernetes (2.36.0), cloudflare (5.2.0), fastly (5.17.0), vercel (~> 1.0).

## Coding Conventions

- Two-space indentation; resources sorted alphabetically within files
- Resource naming: `<service>_<component>_<env>` (e.g., `cloudflare_zone_api_staging`)
- Run `terraform fmt` after edits (enforced by lefthook pre-commit hook)
- Credentials via environment variables or CI secrets — never in Git

## CI

GitHub Actions (`.github/workflows/integration.yml`) runs on push to `main`/`develop` and PRs to `main`: `terraform fmt -check -recursive` → `terraform init -backend=false` → `terraform validate`.

## Git Workflow

- Main branch: `main`; development branch: `develop`
- Imperative commit messages (e.g., "Add Fastly provider aliases"); optional `[infra]` scope prefix
- PRs must include: summary, environments touched, plan output evidence, manual steps needed
