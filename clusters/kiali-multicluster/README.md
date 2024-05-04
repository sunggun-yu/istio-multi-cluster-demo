# Kiali Multi Cluster Configuration

## Prepare merged KUBECONFIG

merging 3 clusters kubeconfig file into one.

```bash
KUBECONFIG=~/.kube/meowhq-k3s-bee1:~/.kube/meowhq-k3s-bee2:~/.kube/meowhq-k3s-xeon1 \
kubectl config view --flatten > ~/.kube/meowhq-k3s-all
```

and create ENVP profile with merged kubeconfig

```yaml
profiles:
...
  meowhq-k3s-all:
    desc: meowhq-k3s
    env:
    - name: KUBECONFIG
      value: ~/.kube/meowhq-k3s-all
```

## Configure Kiali Multi Cluster

Ref: <https://kiali.io/docs/configuration/multi-cluster/>

### Create remote resources

- Create a Kiali Service Account in the remote cluster.
- Create a role/role-binding for this service account in the remote cluster.

meowhq-k3s-bee1:

```bash
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --process-kiali-secret false \
  --remote-cluster-context meowhq-k3s-bee1 \
  --process-remote-resources true \
  --view-only false
```

meowhq-k3s-bee2:

```bash
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --process-kiali-secret false \
  --remote-cluster-context meowhq-k3s-bee2 \
  --process-remote-resources true \
  --view-only false
```

meowhq-k3s-xeon1:

```bash
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --process-kiali-secret false \
  --remote-cluster-context meowhq-k3s-xeon1 \
  --process-remote-resources true \
  --view-only false
```

### Create remote cluster secrets

meowhq-k3s-bee1:

```bash
# bee1 -> bee2
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-bee1 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-bee2 \
  --process-remote-resources false \
  --view-only false

# bee1 -> xeon1
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-bee1 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-xeon1 \
  --process-remote-resources false \
  --view-only false
```

meowhq-k3s-bee2:

```bash
# bee2 -> bee1
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-bee2 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-bee1 \
  --process-remote-resources false \
  --view-only false

# bee2 -> xeon1
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-bee2 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-xeon1 \
  --process-remote-resources false \
  --view-only false
```

meowhq-k3s-xeon1:

```bash
# xeon1 -> bee1
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-xeon1 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-bee1 \
  --process-remote-resources false \
  --view-only false

# xeon1 -> bee2
./kiali-prepare-remote-cluster.sh \
  --dry-run false \
  --kiali-cluster-context meowhq-k3s-xeon1 \
  --process-kiali-secret true \
  --remote-cluster-context meowhq-k3s-bee2 \
  --process-remote-resources false \
  --view-only false
```

## Configure Kiali

proceed the `step5` of each clusters
