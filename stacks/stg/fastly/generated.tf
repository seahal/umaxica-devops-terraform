# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "fastly_service_compute" "hono_staging" {
  name          = "reasonably-stunning-gecko.edgecompute.app"
  force_destroy = true

  domain {
    name = "reasonably-stunning-gecko.edgecompute.app"
  }

  package {
    filename         = "placeholder.wasm"
    source_code_hash = "feb886ef98917bf0ba60fddadb811eb59663815ff3751bc3a80893b864b68bd6bb44042cce66e6f23b02184fa3abfdb06e231f4118831520a15b31e705d89c61"
  }

  # wasm はまだ Terraform 管理下に置かないので、import 完了まで差分を無視する。
  # 本番配信を Terraform で行うようになったら、この lifecycle ブロックを外す。
  lifecycle {
    ignore_changes = [package]
  }
}
