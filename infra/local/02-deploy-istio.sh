mkdir -p tmp/repositories/istio

git clone https://github.com/istio/istio.git tmp/repositories/istio

istioctl install --skip-confirmation

kubectl apply -f tmp/repositories/istio/samples/addons
sleep 10
kubectl apply -f tmp/repositories/istio/samples/addons

kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/kiali
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/jaeger
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/prometheus
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/grafana
