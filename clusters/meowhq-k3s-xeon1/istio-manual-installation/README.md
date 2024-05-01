# istio manual installation for multi cluster

## meowhq-k3s-xeon1

install istio with cluster config:

```bash
istioctl install -f iop.yaml
```

or, generate  the manifest from  IstioOperator:

```bash
istioctl manifest generate -f iop.yaml > manifest.yaml
```

create remote secret of my cluster:

```bash
istioctl create-remote-secret \
 --namespace=istio-system \
 --name=meowhq-k3s-xeon1 \
 --server=https://xeon1.k3s.meowhq.dev:6443 \
 > ../../remote-secrets/meowhq-k3s-xeon1.yaml
```

proceed other cluster installation and create the remote secrets. and create other clusters secret to enable  endpoint discovery

```bash
kubectl apply -n istio-system -f ../../remote-secrets/meowhq-k3s-bee1.yaml
kubectl apply -n istio-system -f ../../remote-secrets/meowhq-k3s-bee2.yaml
```

uninstall istio:

```bash
istioctl uninstall --purge
```
