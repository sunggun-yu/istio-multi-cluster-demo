# enable PKI secret engine
resource "vault_mount" "pki_root_ca" {
  path                  = var.root_ca_path
  type                  = "pki"
  description           = var.root_ca_description
  max_lease_ttl_seconds = 315360000 // 87600h, 10 years
}

# generate root CA certificate
resource "vault_pki_secret_backend_root_cert" "pki_root_ca" {
  depends_on   = [vault_mount.pki_root_ca]
  backend      = vault_mount.pki_root_ca.path
  type         = "internal"
  common_name  = var.root_ca_common_name
  organization = var.root_ca_organization
  issuer_name  = var.root_ca_issuer_name
  key_bits     = 4096
  ttl          = "315360000" // 87600h, 10 years
}

# configure URLs for root CA
resource "vault_pki_secret_backend_config_urls" "pki_root_ca" {
  backend = vault_mount.pki_root_ca.path
  issuing_certificates = [
    "${var.vault_server}/v1/${vault_mount.pki_root_ca.path}/ca",
  ]
  crl_distribution_points = [
    "${var.vault_server}/v1/${vault_mount.pki_root_ca.path}/crl"
  ]
}

# create role for root CA
resource "vault_pki_secret_backend_role" "pki_root_ca_issuer" {
  backend        = vault_mount.pki_root_ca.path
  name           = var.root_ca_role_name
  allow_any_name = true
  key_type       = "any"
  max_ttl        = 25920000 // 7200h, 30 days
}
