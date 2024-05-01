# Clusters configuration

- [Step1](#step1)
- [Step2](#step2)
- [Step3](#step3)
- [Step4](#step4)
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

## Step1

Install base packages

- `external-secrets`
- `cert-manager`
- `metallb`
- `istio-namespace`

```bash
kustomize build --enable-helm $ENVP_PROFILE/step1 \
| kubectl apply -f -
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

## Step3

Install Istio manually

- [meowhq-k3s-bee1](./meowhq-k3s-bee1/istio-manual-installation/README.md)
- [meowhq-k3s-bee2](./meowhq-k3s-bee2/istio-manual-installation/README.md)
- [meowhq-k3s-xeon1](./meowhq-k3s-xeon1/istio-manual-installation/README.md)

```bash
istioctl manifest generate \
  -f $ENVP_PROFILE/istio-manual-installation/iop.yaml \
  > $ENVP_PROFILE/istio-manual-installation/manifest.yaml
```

```bash
kubectl apply \
  -f $ENVP_PROFILE/istio-manual-installation/manifest.yaml
```

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-bee1 \
 --server=https://bee1.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-bee1.yaml
```

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-bee2 \
 --server=https://bee2.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-bee2.yaml
```

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-xeon1 \
 --server=https://xeon1.k3s.meowhq.dev:6443 \
 > ./remote-secrets/meowhq-k3s-xeon1.yaml
```

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee2.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-xeon1.yaml
```

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee1.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-xeon1.yaml
```

```bash
kubectl apply -f ./remote-secrets/meowhq-k3s-bee1.yaml
kubectl apply -f ./remote-secrets/meowhq-k3s-bee2.yaml
```

## Step4

Create Gateways

```bash
kustomize build --enable-helm $ENVP_PROFILE/step4 \
| kubectl apply -f -
```

## Deploy test hello-app

```bash
kustomize build --enable-helm $ENVP_PROFILE/hello-app \
| kubectl apply -f -
```
