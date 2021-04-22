# create two sample projects
# one for istio samples
oc new-project bookinfo
# another to play around with knative
oc new-project knative-sandbox

# create the namespace where istio will be deployed
oc new-project istio-system

# wait a minute for the project to initialize
sleep 60

# deploy an istio service mesh control plane
oc apply -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-control-plane.yaml
# create service mesh member rolls (i.e. default, bookinfo, knative-sandbox)
oc apply -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-member-roll.yaml

# give it a few minutes
sleep 120

# wait for operator deployments to complete
oc -n istio-system wait --for=condition=Available  --timeout=720s deployment.apps/grafana
oc -n istio-system wait --for=condition=Available  --timeout=820s deployment.apps/istio-egressgateway
oc -n istio-system wait --for=condition=Available  --timeout=920s deployment.apps/istio-ingressgateway
oc -n istio-system wait --for=condition=Available  --timeout=1020s deployment.apps/istiod-basic 
oc -n istio-system wait --for=condition=Available  --timeout=1120s deployment.apps/jaeger
oc -n istio-system wait --for=condition=Available  --timeout=1220s deployment.apps/prometheus
oc -n istio-system wait --for=condition=Available  --timeout=3000s deployment.apps/kiali
