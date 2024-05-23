# meowhq-istio Helm Chart

Helm Chart for installing and configuring Istio components with Istio official Helm Charts as dependency,

<https://istio.io/latest/docs/setup/install/helm/>

- `istio/base`: Istio base chart which contains cluster-wide Custom Resource Definitions (CRDs) which must be installed prior to the deployment of the Istio control plane
- `istio/istiod`: Istio discovery chart which deploys the istiod service
- `istio/gateway`: Istio ingress gateway

This chart provides installing multiple istio gateway using sub-chart alias,

- `ingressgateway`: default ingress gateway to expose service
- `cross-network-gateway`: cross network gateway to implement Istio Multicluster installation <https://istio.io/latest/docs/setup/install/multicluster/multi-primary_multi-network/>. also, installs Istio Gateway that routes traffic for any hostname with `"*.local"` to the `cross-network-gateway`.
