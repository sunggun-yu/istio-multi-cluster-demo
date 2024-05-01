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
 --namespace=istio-system \
 --name=meowhq-k3s-bee1 \
 --server=https://bee1.k3s.meowhq.dev:6443 \
 > ../../remote-secrets/meowhq-k3s-bee1.yaml
```

proceed other cluster installation and create the remote secrets. and create other clusters secret to enable  endpoint discovery

```bash
kubectl apply -f ../../remote-secrets/meowhq-k3s-bee2.yaml
kubectl apply -f ../../remote-secrets/meowhq-k3s-xeon1.yaml
```

uninstall istio:

```bash
istioctl uninstall --purge
```

## iop.yaml

> it's partial content of file to extract only istio multi cluster related values

```yaml
spec:
  components:
    ingressGateways:
    - name: istio-cross-network-gateway
      label:
        istio: cross-network-gateway
        app: istio-cross-network-gateway
        topology.istio.io/network: meowhq-k3s-bee1
      enabled: true
      k8s:
        env:
          # traffic through this gateway should be routed inside the network
          - name: ISTIO_META_REQUESTED_NETWORK_VIEW
            value: meowhq-k3s-bee1
        service:
          ports:
            - name: tls
              port: 15443
              targetPort: 15443
  values:
    global:
      logging:
        level: "default:debug"
      caAddress: "cert-manager-istio-csr.istio-system.svc:443"
      meshID: meowhq-mesh
      multiCluster:
        clusterName: meowhq-k3s-bee1
      network: meowhq-k3s-bee1
      proxy:
        logLevel: debug
    pilot:
      env:
        ENABLE_CA_SERVER: false
```
