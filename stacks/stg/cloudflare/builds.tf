locals {
  worker_build_trigger_rules = {
    production = {
      branch_includes = ["main"]
      branch_excludes = []
      path_includes   = ["*"]
      path_excludes   = []
      trigger_name    = "Deploy production"
    }
    preview = {
      branch_includes = ["*"]
      branch_excludes = ["main"]
      path_includes   = ["*"]
      path_excludes   = []
      trigger_name    = "Deploy preview branches"
    }
  }

  worker_build_profiles = {
    standard = {
      commands = {
        production = {
          build_command  = "pnpm exec opennextjs-cloudflare build"
          deploy_command = "pnpm exec opennextjs-cloudflare deploy"
        }
        preview = {
          build_command  = "pnpm exec opennextjs-cloudflare build"
          deploy_command = "pnpm exec opennextjs-cloudflare upload"
        }
      }
    }
    apex = {
      commands = {
        production = {
          build_command  = "pnpm --dir org/apex run build"
          deploy_command = "pnpm --dir org/apex exec wrangler deploy"
        }
        preview = {
          build_command  = "pnpm --dir org/apex run build"
          deploy_command = "pnpm --dir org/apex exec wrangler versions upload"
        }
      }
    }
  }

  worker_build_kinds = {
    for worker_name in keys(local.workers) :
    worker_name => (endswith(worker_name, "-apex") ? "apex" : "standard")
  }

  worker_build_targets = {
    for worker_name, kind in local.worker_build_kinds : worker_name => {
      kind           = kind
      root_directory = kind == "apex" ? "/" : replace(replace(worker_name, "umaxica-apps-edge-", ""), "-", "/")
    }
  }

  worker_build_configs = {
    for worker_name, target in local.worker_build_targets : worker_name => {
      for environment, trigger_rule in local.worker_build_trigger_rules : environment => merge(
        trigger_rule,
        local.worker_build_profiles[target.kind].commands[environment],
        {
          root_directory = target.root_directory
        }
      )
    }
  }

  worker_builds_selected = var.cloudflare_workers_builds_workers == null ? local.worker_build_configs : {
    for worker_name, config in local.worker_build_configs : worker_name => config
    if contains(var.cloudflare_workers_builds_workers, worker_name)
  }

  worker_builds_enabled = var.cloudflare_workers_builds_repo_connection_uuid == null ? {} : local.worker_builds_selected
}

resource "terraform_data" "worker_builds" {
  for_each = local.worker_builds_enabled

  input = {
    worker_name = each.key
    config      = each.value
    worker_tag  = cloudflare_worker.workers[each.key].id
  }

  triggers_replace = {
    config_hash = sha1(jsonencode({
      worker_tag = cloudflare_worker.workers[each.key].id
      config     = each.value
    }))
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail

      require() {
        local name="$1"
        local value="$${2:-}"
        if [[ -z "$${value}" ]]; then
          echo "missing required environment variable: $${name}" >&2
          exit 1
        fi
      }

      require CLOUDFLARE_ACCOUNT_ID "$${CLOUDFLARE_ACCOUNT_ID:-}"
      require CLOUDFLARE_API_TOKEN "$${CLOUDFLARE_API_TOKEN:-}"
      require WORKER_NAME "$${WORKER_NAME:-}"
      require WORKER_TAG "$${WORKER_TAG:-}"
      require WORKER_CONFIG_JSON "$${WORKER_CONFIG_JSON:-}"

      api() {
        local method="$1"
        local path="$2"
        local data="$${3:-}"

        if [[ -n "$${data}" ]]; then
          curl -sS --fail \
            -X "$${method}" \
            "https://api.cloudflare.com/client/v4/accounts/$${CLOUDFLARE_ACCOUNT_ID}$${path}" \
            -H "Authorization: Bearer $${CLOUDFLARE_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "$${data}"
        else
          curl -sS --fail \
            -X "$${method}" \
            "https://api.cloudflare.com/client/v4/accounts/$${CLOUDFLARE_ACCOUNT_ID}$${path}" \
            -H "Authorization: Bearer $${CLOUDFLARE_API_TOKEN}" \
            -H "Content-Type: application/json"
        fi
      }

      list_triggers() {
        api GET "/builds/triggers" | jq -c '.result[]?'
      }

      upsert_trigger() {
        local name="$1"
        local payload="$2"
        local trigger_uuid

        trigger_uuid="$(
          list_triggers | jq -r \
            --arg worker_tag "$${WORKER_TAG}" \
            --arg trigger_name "$${name}" \
            'select(.external_script_id == $worker_tag and .trigger_name == $trigger_name) | .uuid' \
            | head -n 1
        )"

        if [[ -n "$${trigger_uuid}" && "$${trigger_uuid}" != "null" ]]; then
          api PATCH "/builds/triggers/$${trigger_uuid}" "$${payload}" >/dev/null
          echo "updated trigger $${name} for $${WORKER_NAME}" >&2
          printf '%s\n' "$${trigger_uuid}"
          return
        fi

        if [[ -z "$${CLOUDFLARE_WORKERS_BUILDS_REPO_CONNECTION_UUID:-}" ]]; then
          echo "missing CLOUDFLARE_WORKERS_BUILDS_REPO_CONNECTION_UUID for trigger creation: $${name}" >&2
          exit 1
        fi

        local create_payload
        create_payload="$(
          jq -n \
            --arg external_script_id "$${WORKER_TAG}" \
            --arg repo_connection_uuid "$${CLOUDFLARE_WORKERS_BUILDS_REPO_CONNECTION_UUID}" \
            --argjson body "$${payload}" \
            '
            {
              external_script_id: $external_script_id,
              repo_connection_uuid: $repo_connection_uuid
            } + $body
            '
        )"

        local response
        response="$$(api POST "/builds/triggers" "$${create_payload}")"
        echo "created trigger $${name} for $${WORKER_NAME}" >&2
        jq -r '.result.uuid' <<<"$${response}"
      }

      sync_env_vars() {
        local trigger_uuid="$1"
        local variables="$2"

        api PATCH "/builds/triggers/$${trigger_uuid}/environment_variables" "{\"variables\": $${variables}}" >/dev/null
      }

      production_payload="$(
        jq -n \
          --arg build_command "$$(jq -r '.production.build_command' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg deploy_command "$$(jq -r '.production.deploy_command' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg root_directory "$$(jq -r '.production.root_directory' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson branch_includes "$$(jq '.production.branch_includes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson branch_excludes "$$(jq '.production.branch_excludes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson path_includes "$$(jq '.production.path_includes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson path_excludes "$$(jq '.production.path_excludes' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg trigger_name "$$(jq -r '.production.trigger_name' <<<"$${WORKER_CONFIG_JSON}")" \
          '
          {
            trigger_name: $trigger_name,
            build_command: $build_command,
            deploy_command: $deploy_command,
            root_directory: $root_directory,
            branch_includes: $branch_includes,
            branch_excludes: $branch_excludes,
            path_includes: $path_includes,
            path_excludes: $path_excludes
          }
          '
      )"

      preview_payload="$(
        jq -n \
          --arg build_command "$$(jq -r '.preview.build_command' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg deploy_command "$$(jq -r '.preview.deploy_command' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg root_directory "$$(jq -r '.preview.root_directory' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson branch_includes "$$(jq '.preview.branch_includes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson branch_excludes "$$(jq '.preview.branch_excludes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson path_includes "$$(jq '.preview.path_includes' <<<"$${WORKER_CONFIG_JSON}")" \
          --argjson path_excludes "$$(jq '.preview.path_excludes' <<<"$${WORKER_CONFIG_JSON}")" \
          --arg trigger_name "$$(jq -r '.preview.trigger_name' <<<"$${WORKER_CONFIG_JSON}")" \
          '
          {
            trigger_name: $trigger_name,
            build_command: $build_command,
            deploy_command: $deploy_command,
            root_directory: $root_directory,
            branch_includes: $branch_includes,
            branch_excludes: $branch_excludes,
            path_includes: $path_includes,
            path_excludes: $path_excludes
          }
          '
      )"

      production_uuid="$$(upsert_trigger "Deploy production" "$${production_payload}" | tail -n 1)"
      preview_uuid="$$(upsert_trigger "Deploy preview branches" "$${preview_payload}" | tail -n 1)"

      production_env="$$(jq -c '.production.environment_variables // []' <<<"$${WORKER_CONFIG_JSON}")"
      preview_env="$$(jq -c '.preview.environment_variables // []' <<<"$${WORKER_CONFIG_JSON}")"

      if [[ -n "$${production_uuid}" && "$${production_uuid}" != "null" ]]; then
        sync_env_vars "$${production_uuid}" "$${production_env}"
      fi
      if [[ -n "$${preview_uuid}" && "$${preview_uuid}" != "null" ]]; then
        sync_env_vars "$${preview_uuid}" "$${preview_env}"
      fi
    EOT
    environment = {
      CLOUDFLARE_ACCOUNT_ID                          = var.account_id
      CLOUDFLARE_WORKERS_BUILDS_REPO_CONNECTION_UUID = var.cloudflare_workers_builds_repo_connection_uuid
      WORKER_NAME                                    = each.key
      WORKER_TAG                                     = cloudflare_worker.workers[each.key].id
      WORKER_CONFIG_JSON                             = jsonencode(each.value)
    }
  }
}
