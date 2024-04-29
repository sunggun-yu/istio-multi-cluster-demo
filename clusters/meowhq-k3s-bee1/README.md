# istio multi cluster meowhq-k3s-xeon1 : manual cert

create secret in `istio-system` namespace:

```bash
kubectl create secret generic cacerts -n istio-system \
--from-file=ca-cert.pem \
--from-file=ca-key.pem \
--from-file=root-cert.pem \
--from-file=cert-chain.pem
```

install istio with cluster config:

```bash
istioctl install -f iop.yaml
```

expose services:

```bash
kubectl apply -f expose-mc-svcs.yaml
```

create remote secret of my cluster:

```bash
istioctl create-remote-secret \
 --name=meowhq-k3s-bee1 \
 --server=https://bee1.k3s.meowhq.dev:6443 \
 > cluster-secrets-mine.yaml
```

```bash
istioctl create-remote-secret \
 --name=meowhq-k3s-xeon1 \
 --server="$(kubectl cluster-info | grep 'Kubernetes control plane' | awk '{print $NF}')" \
 > cluster-secrets-mine.yaml
```

copy other clusters remote secret in clsuter-secrets.yaml and enable endpoint discovery of other clusters:

```bash
kubectl apply -f cluster-secrets.yaml
```

create cert:

```bash
kubectl apply -f demo-wildcard.yaml
```

create ingressgw:

```bash
kubectl apply -f ingressgateway.yaml
```

create sample ns:

```bash
kubectl create ns sample
kubectl label ns sample istio-injection=enabled --overwrite
```

create sample service:

```bash
k apply -f https://raw.githubusercontent.com/istio/istio/master/samples/helloworld/helloworld.yaml -l service=helloworld -n sample
```

create virtual service:

```bash
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  labels:
    app: helloworld
    service: helloworld
  name: helloworld
  namespace: sample
spec:
  gateways:
  - istio-system/demo-meowhq-dev-gw
  hosts:
  - helloworld.demo.meowhq.dev
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: helloworld.sample.svc.cluster.local
        port:
          number: 5000
EOF
```

create sample deployment:

```bash
k apply -n sample -f https://raw.githubusercontent.com/istio/istio/master/samples/helloworld/helloworld.yaml -l version=v1

k apply -n sample -f https://raw.githubusercontent.com/istio/istio/master/samples/helloworld/helloworld.yaml -l version=v2
```

testing from other ns:

```bash
kubectl create ns demo
kubectl label namespace demo istio-injection=enabled --overwrite
k run -n demo -it --rm --image=sunggun/net-test -- bash
curl helloworld.sample.svc.cluster.local:5000/hello
```
