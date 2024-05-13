# Create the policy for the Istio Intermediate CA AppRole
resource "vault_policy" "pki_istio_int_ca" {
  name   = var.istio_int_ca_policy_name
  policy = <<EOT
path "${vault_mount.pki_istio_int_ca.path}/sign/issuer" {
  capabilities = ["create", "update"]
}
EOT
}

# Enable AppRole Auth Method
resource "vault_auth_backend" "istio_int_ca" {
  path        = var.istio_int_ca_approle_path
  type        = "approle"
  description = "AppRole authentication backend for the Istio Intermediate CA"
}

# Create AppRole Role ID
resource "vault_approle_auth_backend_role" "istio_int_ca" {
  backend        = vault_auth_backend.istio_int_ca.path
  role_name      = "istio-int-ca-issuer"
  token_policies = ["${vault_policy.pki_istio_int_ca.name}"]
}

# Create AppRole Secret ID
resource "vault_approle_auth_backend_role_secret_id" "istio_int_ca" {
  backend   = vault_auth_backend.istio_int_ca.path
  role_name = vault_approle_auth_backend_role.istio_int_ca.role_name
}

# Store AppRole ID and Secret ID in the Vault secret engine.
resource "vault_kv_secret_v2" "istio_int_ca_secret_id" {
  mount               = var.secret_engine_path
  name                = var.secret_name_istio_int_ca_approle_secret_id
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      role_id   = "${vault_approle_auth_backend_role.istio_int_ca.role_id}",
      secret_id = "${vault_approle_auth_backend_role_secret_id.istio_int_ca.secret_id}",
    }
  )
  custom_metadata {
    max_versions = 1
    data = {
      description = "Secret ID for the AppRole of the Istio Intermediate CA",
    }
  }
}
