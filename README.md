[![CI](https://github.com/seahal/umaxica-devops-terraform/actions/workflows/integration.yml/badge.svg?branch=main)](https://github.com/seahal/umaxica-devops-terraform/actions/workflows/integration.yml)

# UMAXICA (Terraform)

Multi-cloud infrastructure managed with OpenTofu.

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.9.0
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

## Running OpenTofu

Each directory under `live/` is an independent OpenTofu root. Use `-chdir` to target the environment you want to operate on.

```bash
# Staging
tofu -chdir=live/stg/aws/ap-northeast-1/app plan
tofu -chdir=live/stg/cloudflare plan
tofu -chdir=live/stg/vercel plan

# Production
tofu -chdir=live/prod/aws/ap-northeast-1/app plan
tofu -chdir=live/prod/cloudflare plan
tofu -chdir=live/prod/vercel plan
```

Replace `plan` with `apply` to apply changes, or `init` for first-time setup.

## Useful Tools

- [Lefthook](https://github.com/evilmartians/lefthook)
- [tflint](https://github.com/terraform-linters/tflint)
- [asdf](https://asdf-vm.com/)
- [yamlfmt](https://github.com/google/yamlfmt)
