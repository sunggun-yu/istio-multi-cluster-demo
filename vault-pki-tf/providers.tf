terraform {
  required_version = ">= 1.5.0"
  required_providers {
    vault = "~> 4.2.0"
  }
}

# VAULT_ADDR and VAULT_TOKEN are set in the environment variables
provider "vault" {}
