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

Use a Cloudflare API token when operating `stacks/stg/cloudflare` or `stacks/prod/cloudflare`:

```bash
export CLOUDFLARE_API_TOKEN=...
```

## Development Container

The repository includes a multi-cloud devcontainer in `.devcontainer/`.
It comes with Terraform, TFLint, terraform-docs, AWS CLI, Google Cloud CLI, Vercel CLI, pre-commit, and Lefthook.

The container mounts your host `~/.aws`, `~/.config/gcloud`, `~/.ssh`, and `~/.gitconfig` so existing credentials and Git config are available without baking secrets into the image.

Open it from VS Code with "Reopen in Container", or use the Dev Containers CLI if you prefer a terminal workflow.

## Running Terraform

Each directory under `stacks/` is an independent Terraform root. Use `-chdir` to target the environment you want to operate on.

```bash
# Staging
terraform -chdir=stacks/stg/aws/ap-northeast-1/app plan
terraform -chdir=stacks/stg/vercel plan

# Cloudflare staging uses the local token in stacks/stg/cloudflare/.env
source stacks/stg/cloudflare/.env
terraform -chdir=stacks/stg/cloudflare plan

# Production
terraform -chdir=stacks/prod/aws/ap-northeast-1/app plan
terraform -chdir=stacks/prod/cloudflare plan
terraform -chdir=stacks/prod/vercel plan
```

Replace `plan` with `apply` to apply changes, or `init` for first-time setup.

## Useful Tools

- [Lefthook](https://github.com/evilmartians/lefthook)
- [tflint](https://github.com/terraform-linters/tflint)
- [asdf](https://asdf-vm.com/)
- [yamlfmt](https://github.com/google/yamlfmt)
