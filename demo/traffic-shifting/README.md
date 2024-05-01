# Weighted Traffic Shifting

## Prerequisite

Create Destination Rule in all clusters:

> 💡Important!
>
> you must create it in all clusters

```bash
envp meowhq-k3s-bee1 -- \
  kubectl apply -f destination-rule.yaml

envp meowhq-k3s-bee2 -- \
  kubectl apply -f destination-rule.yaml

envp meowhq-k3s-xeon1 -- \
  kubectl apply -f destination-rule.yaml
```

## Cross Network Gateway Traffic

> Testing on `meowhq-k3s-xeon`

Create the VirtualService for local DNS host `hello.hello.svc.cluster.local` :

```bash
envp meowhq-k3s-xeon1 -- \
  kubectl apply -f hello-weighted-route-local.yaml
```

```bash
envp meowhq-k3s-bee1 -- \
  kubectl apply -f hello-weighted-route-local.yaml
```

```bash
envp meowhq-k3s-bee2 -- \
  kubectl apply -f hello-weighted-route-local.yaml
```

Create other namespace/pod to send traffic from there:

```bash
# create ns
envp meowhq-k3s-xeon1 -- \
  kubectl create ns demo

# enable istio injection - must to do
envp meowhq-k3s-xeon1 -- \
  kubectl label ns demo istio-injection=enabled
```

Create a pod and attach into it:

```bash
envp meowhq-k3s-xeon1 -- \
  kubectl run -n demo -it --rm --image=sunggun/net-test -- bash
```

Send some traffic with local DNS `hello.hello.svc.cluster.local`:

```bash
for i in {1..100}; do curl hello.hello.svc.cluster.local:8080/hello; done
```

## Ingress Gateway Traffic

> - Testing on `meowhq-k3s-xeon`
>
> - Testing on some virtual machine that you can modify `/etc/hosts` file

Create the VirtualService for local DNS host `hello.hello.svc.cluster.local` :

```bash
envp meowhq-k3s-xeon1 -- \
  kubectl apply -f hello-weighted-route-global.yaml
```

SSH into some VM:

```bash
ssh meowhq@192.168.2.139
```

Update the `/etc/hosts` file and point `hello.demo.meowhq.dev` to ingressgateway IP of `meowhq-k3s-xeon1` cluster.

```bash
echo "192.168.10.25   hello.demo.meowhq.dev" | sudo tee -a /etc/hosts
```

```bash
for i in {1..100}; do curl https://hello.demo.meowhq.dev/hello; done
```

finally create VS in all cluster and check from browser

```bash
envp meowhq-k3s-bee1 -- \
  kubectl apply -f hello-weighted-route-global.yaml

envp meowhq-k3s-bee2 -- \
  kubectl apply -f hello-weighted-route-global.yaml

envp meowhq-k3s-xeon1 -- \
  kubectl apply -f hello-weighted-route-global.yaml
```
