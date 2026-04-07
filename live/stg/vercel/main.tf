resource "vercel_project" "umaxica_apps_edge_dev_core" {
  name      = "umaxica-apps-edge-dev-core"
  framework = "nextjs"

  git_repository = {
    type = "github"
    repo = "seahal/umaxica-apps-edge"
  }
}
