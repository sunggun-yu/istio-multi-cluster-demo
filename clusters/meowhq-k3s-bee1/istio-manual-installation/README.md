# istio manual installation for multi cluster

## meowhq-k3s-bee1

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
 --name=meowhq-k3s-bee1 \
 --server=https://bee1.k3s.meowhq.dev:6443 \
 > ../../remote-secrets/meowhq-k3s-bee1.yaml
```

proceed other cluster installation and create the remote secrets. and create other clusters secret to enable  endpoint discovery

```bash
kubectl apply -f ../../remote-secrets/meowhq-k3s-bee2.yaml
kubectl apply -f ../../remote-secrets/meowhq-k3s-xeon1.yaml
```
