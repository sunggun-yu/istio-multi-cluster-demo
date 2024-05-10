variable "vault_server" {
  description = "vault server url"
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
