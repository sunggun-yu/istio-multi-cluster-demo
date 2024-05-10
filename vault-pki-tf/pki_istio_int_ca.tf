# enable PKI secret engine
resource "vault_mount" "pki_istio_int_ca" {
  path                  = var.istio_int_ca_path
  type                  = "pki"
  description           = var.istio_int_ca_description
  max_lease_ttl_seconds = 315360000 // 87600h, 10 years
  depends_on            = [vault_mount.pki_root_ca]
}

# generate intermediate CA certificate
resource "vault_pki_secret_backend_intermediate_cert_request" "pki_istio_int_ca" {
  depends_on   = [vault_mount.pki_istio_int_ca]
  backend      = vault_mount.pki_istio_int_ca.path
  type         = "internal"
  common_name  = var.istio_int_ca_common_name
  organization = var.istio_int_ca_organization
  key_bits     = 4096
}

# sign intermediate CA certificate with root CA
resource "vault_pki_secret_backend_root_sign_intermediate" "pki_root_ca" {
  depends_on  = [vault_pki_secret_backend_intermediate_cert_request.pki_istio_int_ca]
  backend     = vault_mount.pki_root_ca.path
  common_name = var.istio_int_ca_common_name
  issuer_ref  = vault_pki_secret_backend_root_cert.pki_root_ca.issuer_id
  csr         = vault_pki_secret_backend_intermediate_cert_request.pki_istio_int_ca.csr
  format      = "pem"
  ttl         = 315360000 // 87600h, 10 years
}

# make signed ca chain certificate
locals {
  # is ca_chain order correct? it seems root ca certificate comes at [1] all the time?
  # should I reverse the order?
  # it seems the result is same no matter what order I use. maybe terraform provider handles order internally?
  # this order worked in anyways lol
  signed_ca_chain = join("\n", vault_pki_secret_backend_root_sign_intermediate.pki_root_ca.ca_chain)
  # signed_ca_chain = join("\n", reverse(vault_pki_secret_backend_root_sign_intermediate.pki_root_ca.ca_chain))

  # manually construct the ca_chain in order might be safer?
  # signed_ca_chain = join("\n", [vault_pki_secret_backend_root_cert.pki_root_ca.certificate, vault_pki_secret_backend_root_sign_intermediate.pki_root_ca.certificate])
}

# set signed chain intermediate CA certificate
resource "vault_pki_secret_backend_intermediate_set_signed" "pki_istio_int_ca" {
  backend     = vault_mount.pki_istio_int_ca.path
  certificate = local.signed_ca_chain
}

# configure URLs for intermediate CA
resource "vault_pki_secret_backend_config_urls" "pki_istio_int_ca" {
  backend = vault_mount.pki_istio_int_ca.path
  issuing_certificates = [
    "${var.vault_server}/v1/${vault_mount.pki_istio_int_ca.path}/ca",
  ]
  crl_distribution_points = [
    "${var.vault_server}/v1/${vault_mount.pki_istio_int_ca.path}/crl"
  ]
}

# create role for intermediate CA
resource "vault_pki_secret_backend_role" "pki_istio_int_ca" {
  backend           = vault_mount.pki_istio_int_ca.path
  name              = var.istio_int_ca_role_name
  allowed_domains   = ["istio-ca"]
  allow_any_name    = true
  enforce_hostnames = false
  require_cn        = false
  allowed_uri_sans  = ["spiffe://*"]
  max_ttl           = 315360000 // 87600h, 10 years
}
