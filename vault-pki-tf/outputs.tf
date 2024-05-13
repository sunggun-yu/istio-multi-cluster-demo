# output is not required, but it is useful to see the output of the terraform apply command

# output "root_ca_certificate" {
#   description = "root ca certificate"
#   value       = vault_pki_secret_backend_root_cert.pki_root_ca.certificate
# }

# output "pki_istio_int_ca_csr" {
#   description = "root ca private key"
#   value       = vault_pki_secret_backend_intermediate_cert_request.pki_istio_int_ca.csr
# }

# output "pki_istio_int_ca_signed_certificate" {
#   description = "root ca private key"
#   value       = vault_pki_secret_backend_root_sign_intermediate.pki_root_ca.ca_chain
# }

# output "signed_ca_chain" {
#   description = "root ca private key"
#   value       = local.signed_ca_chain
# }

output "pki_istio_int_ca_approle_role_id" {
  description = "Istio Intermediate CA ApprRole role id"
  value       = vault_approle_auth_backend_role.istio_int_ca.role_id
}
