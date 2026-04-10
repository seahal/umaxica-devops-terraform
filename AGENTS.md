# Repository Guidelines

## Project Structure & Module Organization
Each directory under `stacks/` is an independent Terraform root. Keep shared code in `modules/` and helper artifacts in `files/`, `templates/`, or `scripts/`. Track security policies in `SECURITY.md`, and automate formatting via `lefthook.yml`.

## Build, Test, and Development Commands
- `asdf install terraform 1.11.2 && asdf install tflint latest` — install the toolchain required by `versions.tf`.
- `terraform -chdir=stacks/stg/aws/ap-northeast-1/app init` (swap the root as needed) — initialize the environment-specific backend and providers.
- `terraform -chdir=stacks/stg/aws/ap-northeast-1/app plan` — generate the plan reviewers must approve before `apply`.
- `lefthook run pre-commit` — runs the configured `terraform fmt`.
- `tflint --chdir stacks/stg/aws/ap-northeast-1/app` / `yamlfmt .` — lint Terraform and YAML respectively.

## Coding Style & Naming Conventions
Use two-space indentation and keep resources sorted alphabetically within a file. Name resources `<service>_<component>_<env>` (for example, `cloudflare_zone_api_staging`) and keep provider aliases consistent with that pattern. Run `terraform fmt`, `yamlfmt`, or `shfmt` after edits and document required environment variables at the top of every script or template.

## Testing Guidelines
Attach every `terraform plan` (or CI artifact link) to the review so it doubles as a regression test. Run `terraform fmt -check`, `terraform validate`, and `tflint` inside each root before planning, and call out any intentional drift in the PR body. When adding modules, include a slim example under `stacks/` so reviewers can exercise the new code path quickly.

## Commit & Pull Request Guidelines
Write imperative commits (e.g., `Add Fastly provider aliases`) and optionally add scopes like `[infra]` to mirror history. Pull requests must include a short summary, environments touched, evidence (plan links, screenshots, logs), and any manual steps or secrets required to apply safely. Request review from an infra maintainer and avoid force-pushes after feedback begins.

## Security & Configuration Tips
Keep credentials out of Git: export `AWS_PROFILE`, `CLOUDFLARE_API_TOKEN`, Fastly, Vercel, and Kubernetes tokens in your shell or CI secrets store. Keep sensitive backend values untracked. Treat `files/` and `templates/` as public unless encrypted, and follow `SECURITY.md` for disclosure or incident handling.
