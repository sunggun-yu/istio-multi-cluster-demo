variable "vault_server" {
  description = "Vault server url"
  type        = string
}

variable "root_ca_path" {
  description = "value of the path to the root CA engine in vault"
  type        = string
}

variable "root_ca_description" {
  description = "description of the root CA engine in vault"
  type        = string
  default     = "Root CA PKI engine"
}

variable "root_ca_common_name" {
  description = "common name of the root CA"
  type        = string
  default     = "Root CA"
}

variable "root_ca_organization" {
  description = "organization of the root CA"
  type        = string
}

variable "root_ca_issuer_name" {
  description = "issuer name of the root CA"
  type        = string
}

variable "root_ca_role_name" {
  description = "role name of the root CA"
  type        = string
  default     = "issuer"
}

variable "istio_int_ca_path" {
  description = "value of the path to the istio intermediate CA engine in vault"
  type        = string
}

variable "istio_int_ca_description" {
  description = "description of the istio intermediate CA engine in vault"
  type        = string
  default     = "Root CA PKI engine"
}

variable "istio_int_ca_common_name" {
  description = "common name of the istio intermediate CA"
  type        = string
  default     = "Root CA"
}

variable "istio_int_ca_organization" {
  description = "organization of the istio intermediate CA"
  type        = string
}

variable "istio_int_ca_role_name" {
  description = "role name of the istio intermediate CA"
  type        = string
  default     = "issuer"
}

variable "istio_int_ca_policy_name" {
  description = "policy name of the istio intermediate CA"
  type        = string
}

variable "istio_int_ca_approle_path" {
  description = "path of the approle for the istio intermediate CA"
  type        = string
}

variable "secret_engine_path" {
  description = "Vault Secret Engine Path to store the secret id for the approle of the istio intermediate CA"
  type        = string
}

variable "secret_name_istio_int_ca_approle_secret_id" {
  description = "vault secret path for the secret id of the approle for the istio intermediate CA"
  type        = string
}
