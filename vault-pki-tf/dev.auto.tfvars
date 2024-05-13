# Vault Server
vault_server = "https://vault.lab.meowhq.dev"

# PKI Root CA
root_ca_path         = "pki/meowhq/istio_root_ca"
root_ca_description  = "MeowHQ Istio Root CA PKI engine"
root_ca_common_name  = "MeowHQ Istio Root CA"
root_ca_organization = "MeowHQ"
root_ca_issuer_name  = "meowhq-istio-root-ca"
root_ca_role_name    = "issuer"

# PKI Istio Intermediate CA
istio_int_ca_path         = "pki/meowhq/istio_int_ca"
istio_int_ca_description  = "MeowHQ Istio Intermediate CA PKI engine"
istio_int_ca_common_name  = "istio-ca" # better not to change this. you need to update helm values if you change this
istio_int_ca_organization = "MeowHQ"
istio_int_ca_role_name    = "issuer"

# AppRole
istio_int_ca_policy_name                   = "meowhq-istio-int-ca-policy"
istio_int_ca_approle_path                  = "meowhq-istio-int-ca-role"
secret_engine_path                         = "internal"
secret_name_istio_int_ca_approle_secret_id = "meowhq/vault/approle/istio-int-ca"
