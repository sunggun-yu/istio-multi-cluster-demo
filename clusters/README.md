# Clusters configuration

- [Pre-requisites](#pre-requisites)
- [Step1](#step1)
- [Step2](#step2)
- [Step3](#step3)
  - [Create Istio Remote Secrets](#create-istio-remote-secrets)
- [Step4](#step4)
- [Step5](#step5)
  - [Configure Kiali Remote Secrets for multi cluster](#configure-kiali-remote-secrets-for-multi-cluster)
  - [Installing Monitoring packages](#installing-monitoring-packages)
- [Deploy test hello-app](#deploy-test-hello-app)

----

Installing Istio in [Install Multi-Primary on different networks](https://istio.io/latest/docs/setup/install/multicluster/multi-primary_multi-network/)

> 💡 Note
>
> All instructions are using [ENVP](https://github.com/sunggun-yu/envp) for environment variables and context switching

```bash
# meowhq-k3s-bee1 profile has environment variable,
# KUBECONFIG file path for the specific cluster
envp start meowhq-k3s-bee1

# open new terminal and start session for meowhq-k3s-bee2
envp start meowhq-k3s-bee2/

# open new terminal and start session for meowhq-k3s-xeon1
envp start meowhq-k3s-xeon1
```

## Pre-requisites

- Provision Vault PKI Engines [Vault PKI Engines](../docs/configure-vault-pki-engines.md)

## Step1

Install base packages

- `external-secrets`
- `cert-manager`
- `metallb`
- `istio-namespace`

Install:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step1 \
| kubectl apply -f -
```

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step1 \
| kubectl delete -f -
```

## Step2

Install Vault Cert Issuer and istio-csr

- `istio-ca-issuer`: Cert Issuer and ExternalSecret to provide the `AppRole` secret.
- `cert-manager/istio-csr`: istio-csr package with cluster specific configurations

```bash
kustomize build --enable-helm $ENVP_PROFILE/step2 \
| kubectl apply -f -
```

Wait and verify if cert has created. and process next once it verified

you should see `istiod`:

```bash
kubectl get cert -n istio-system
```

you should see some request like `istiod-1` and READY is `true`:

```bash
kubectl get certificaterequests -n istio-system
```

you should see `istiod-tls` secret:

```bash
kubectl get secrets -n istio-system
```

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step2 \
| kubectl delete -f -

kubectl delete secrets -n istio-system istiod-tls
```

## Step3

- `istio-base`: Istio CR
- `istiod`: Istio Discovery

Install:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step3 \
| kubectl apply -f -
```

> recycle gateways pods manually if is is not coming up like ImagePullBackOff or something like that

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step3 \
| kubectl delete -f -
```

### Create Istio Remote Secrets

Create Istio Remote Secrets after installing Istio Components

run in `meowhq-k3s-bee1` k8s context:

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-bee1 \
 --server=https://bee1.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-bee1.yaml
```

run in `meowhq-k3s-bee2` k8s context:

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-bee2 \
 --server=https://bee2.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-bee2.yaml
```

run in `meowhq-k3s-xeon1` k8s context:

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-xeon1 \
 --server=https://xeon1.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-xeon1.yaml
```

run in `meowhq-k3s-bee1` k8s context:

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee2.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-xeon1.yaml
```

run in `meowhq-k3s-bee2` k8s context:

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee1.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-xeon1.yaml
```

run in `meowhq-k3s-xeon1` k8s context:

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee1.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-bee2.yaml
```

clean up:

```bash
kubectl delete -f ./remote-secrets/meowhq-k3s-bee1.yaml
kubectl delete -f ./remote-secrets/meowhq-k3s-bee2.yaml
kubectl delete -f ./remote-secrets/meowhq-k3s-xeon1.yaml
```

## Step4

- `istio-cross-network-gateway`: Istio Multicluster Network Gateway
- `istio-ingressgateway`: Istio Ingress Gateway
- Istio GateWay Resources

Install:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step4 \
| kubectl apply -f -
```

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step4 \
| kubectl delete -f -
```

## Step5

Config Monitoring packages

### Configure Kiali Remote Secrets for multi cluster

Ref: [Kiali Multi Cluster Configuration](./kiali-multicluster/README.md)

### Installing Monitoring packages

- Prometheus
- Grafana
- Kiali
- Jaeger

Install:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step5 \
| kubectl apply -f -
```

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/step5 \
| kubectl delete -f -
```

## Deploy test hello-app

Install:

```bash
kustomize build --enable-helm $ENVP_PROFILE/hello-app \
| kubectl apply -f -
```

Cleanup:

```bash
kustomize build --enable-helm $ENVP_PROFILE/hello-app \
| kubectl delete -f -
```
