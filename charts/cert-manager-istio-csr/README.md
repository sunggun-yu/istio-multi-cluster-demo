# cert-manager istio-csr helm chart

istio-csr is an agent that allows for Istio workload and control plane components to be secured using cert-manager.

- <https://cert-manager.io/docs/usage/istio-csr/>
- <https://github.com/cert-manager/istio-csr>

## Purpose

The primary purpose of this Helm chart is to configure Istio CSR for multi-cluster Istio service mesh setups. It achieves this by:

- Configuring the Issuer for the Vault PKI engine in the Istio cluster.
- Installing the istio-csr Helm chart.

## Installation

please install this chart in `istio-system` namespace

```bash
helm dependency update
helm template -n istio-system charts/cert-manager-istio-csr
```

## Usage

> all the helm value for `istio-csr` chart should be under `cert-manager-istio-csr` since it's treated as dependency of this Helm Chart.

- `vault.istioIntermediateCAPath`: the PKI secret engine path for istio intermediate CA cert
- `vault.auth.approle.path`: the Vault auth path for approle that is being used to pull CA from istio intermediate CA PKI engine
- `vault.auth.approle.roleId`: the Vault approle RoleID for approle auth path
- `vault.auth.approle.secretIdSecretPath`: the Vault secret path that stores approle secret ID
- `vault.secretStoreRef.kind`: the ExternalSecret secret store kind. default is `ClusterSecretStore`
- `vault.secretStoreRef.name`: the ExternalSecret secret store name of kind. default is `platform-services-clustersecretstore`
- `cert-manager-istio-csr.app.server.clusterID`: The istio cluster ID to verify incoming CSRs. set your cluster ID in istio mesh

> please check the `values.yaml` file to know default values of this Helm Chart.
>
> please refer to <https://github.com/cert-manager/istio-csr/blob/main/deploy/charts/istio-csr/README.md> for more detail about `istio-csr` helm chart and values.

### about approle ID

The `cert-manager` Issuer provides integration with Vault using various authentication methods. However, it does not support the `JWT` authentication method. Therefore, we are using the approle authentication method for the PKI secret engine. The PKI engine provisioning Terraform workflow configures the PKI engine and approle, and stores the secret ID in the platform service secret engine. That is why this chart has an external-secret to pull the secret ID from the Vault secret engine.

```yaml
vault:
  server: https://vault.lab.meowhq.dev
  istioIntermediateCAPath: "pki/meowhq/istio_int_ca"
  auth:
    approle:
      path: "meowhq-istio-int-ca-role"
      roleId: "17f92c87-35f4-d496-db29-8c236cc1651e"
      secretIdSecretPath: "meowhq/vault/approle/istio-int-ca"
  secretStoreRef:
    kind: ClusterSecretStore
    name: vault-backend-cluster-jwt
```

which means,

- the Vault PKI engine is created at the path `pki/meowhq/istio_int_ca`
- the auth of approle ID to use this PKI engine is `17f92c87-35f4-d496-db29-8c236cc1651e`
- the secret is stored in the Vault secret path `meowhq/vault/approle/istio-int-ca`
- the k8s secret will be created by external-secret using ClusterSecretStore `vault-backend-cluster-jwt`
