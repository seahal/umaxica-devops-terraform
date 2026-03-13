# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Umaxica DevOps Terraform — multi-cloud infrastructure for the Umaxica platform. Manages resources across GCP, AWS, Azure, Cloudflare, Fastly, Vercel, and Kubernetes using OpenTofu (Terraform-compatible OSS).

## Architecture

- **`modules/`** — reusable OpenTofu modules
  - `aws-app/` — S3 static site bucket (versioning + website config)
  - `aws-network/` — AWS networking (skeleton)
  - `gcp-cloud-run/` — GCP Cloud Run (skeleton)
- **`live/`** — environment + cloud + region directory tree; each leaf is an independent OpenTofu root
  - `live/{stg,prod}/aws/ap-northeast-1/{network,app}/` — AWS resources per environment
  - `live/stg/gcp/asia-northeast1/storage/` — GCS buckets for staging
- **Root `.tf` files** — shared providers (`providers.tf`), version constraints (`versions.tf`), variables (`variables.tf`), locals, outputs, and Cloudflare config (`cloudflare.tf`)
- **`s3backend/backend.tf`** — S3 remote state backend config (AWS `ap-northeast-1`, uses S3 native locking)
- **`files/` / `templates/` / `scripts/`** — helper artifacts (currently placeholder `.keep` files)

## Common Commands

```bash
# Install toolchain (requires asdf)
asdf install opentofu 1.9.0 && asdf install tflint latest

# Initialize a live environment
tofu -chdir=live/stg/aws/ap-northeast-1/app init
tofu -chdir=live/prod/aws/ap-northeast-1/app init

# Plan (review before apply)
tofu -chdir=live/stg/aws/ap-northeast-1/app plan

# Format and lint
tofu fmt -recursive              # auto-format all .tf files
tofu fmt -check -recursive       # CI format check
tofu validate                    # validate config
tflint --chdir live/stg/aws/ap-northeast-1/app  # lint
yamlfmt .                        # format YAML files

# Run pre-commit hooks manually
lefthook run pre-commit
```

## Providers (versions.tf)

OpenTofu >= 1.9.0. Required providers: google (~> 7.0), aws (~> 5.0), azurerm (~> 3.24.0), kubernetes (2.36.0), cloudflare (5.2.0), fastly (5.17.0), vercel (~> 1.0).

## Coding Conventions

- Two-space indentation; resources sorted alphabetically within files
- Resource naming: `<service>_<component>_<env>` (e.g., `cloudflare_zone_api_staging`)
- Run `tofu fmt` after edits (enforced by lefthook pre-commit hook)
- Credentials via environment variables or CI secrets — never in Git

## CI

GitHub Actions (`.github/workflows/integration.yml`) runs on push to `main`/`develop` and PRs to `main`: `tofu fmt -check` → `tofu init` → `tofu validate` → `tofu plan`.

## Git Workflow

- Main branch: `main`; development branch: `develop`
- Imperative commit messages (e.g., "Add Fastly provider aliases"); optional `[infra]` scope prefix
- PRs must include: summary, environments touched, plan output evidence, manual steps needed
