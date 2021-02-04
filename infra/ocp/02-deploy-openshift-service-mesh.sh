oc new-project bookinfo
oc new-project knative-sandbox
oc new-project istio-system

sleep 10

oc apply -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-control-plane.yaml
oc apply -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-member-roll.yaml

sleep 120

kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/grafana
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/istio-egressgateway
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/istio-ingressgateway
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/istiod-basic 
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/jaeger
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/kiali
kubectl -n istio-system wait --for=condition=Available  --timeout=360s deployment.apps/prometheus
