[![CI](https://github.com/seahal/umaxica-devops-terraform/actions/workflows/integration.yml/badge.svg?branch=main)](https://github.com/seahal/umaxica-devops-terraform/actions/workflows/integration.yml)

# UMAXICA (Terraform)

Multi-cloud infrastructure managed with Terraform.

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.9.0
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (for SSO login)
- [asdf](https://asdf-vm.com/)
- [Lefthook](https://github.com/evilmartians/lefthook)
- [tflint](https://github.com/terraform-linters/tflint)
- [yamlfmt](https://github.com/google/yamlfmt)

## AWS SSO Login

Before operating AWS resources, log in to the appropriate AWS profile via SSO:

```bash
# Staging
aws sso login --profile stg

# Production
aws sso login --profile prod
```

## Cloudflare Auth

Use a Cloudflare API token when operating `live/stg/cloudflare` or `live/prod/cloudflare`:

```bash
export CLOUDFLARE_API_TOKEN=...
```

## Running Terraform

Each directory under `live/` is an independent Terraform root. Use `-chdir` to target the environment you want to operate on.

```bash
# Staging
terraform -chdir=live/stg/aws/ap-northeast-1/app plan
terraform -chdir=live/stg/vercel plan

# Cloudflare staging uses the local token in live/stg/cloudflare/.env
source live/stg/cloudflare/.env
terraform -chdir=live/stg/cloudflare plan

# Production
terraform -chdir=live/prod/aws/ap-northeast-1/app plan
terraform -chdir=live/prod/cloudflare plan
terraform -chdir=live/prod/vercel plan
```

Replace `plan` with `apply` to apply changes, or `init` for first-time setup.

## Useful Tools

- [Lefthook](https://github.com/evilmartians/lefthook)
- [tflint](https://github.com/terraform-linters/tflint)
- [asdf](https://asdf-vm.com/)
- [yamlfmt](https://github.com/google/yamlfmt)
