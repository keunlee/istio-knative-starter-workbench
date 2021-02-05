# Deploy Istio
istioctl install --skip-confirmation

# Switch namespace
kubens istio-system

# Deploy Istio Addons
mkdir -p tmp/repositories/istio
git clone https://github.com/istio/istio.git tmp/repositories/istio
kubectl apply -f tmp/repositories/istio/samples/addons
sleep 10
# try again, to get the rest of the addons deployed
kubectl apply -f tmp/repositories/istio/samples/addons

# Wait for deployments to complete
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/istiod 
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/istio-ingressgateway
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/kiali
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/jaeger
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/prometheus
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/grafana