# switch to the openshift-operators namespace
oc project openshift-operators

# install the following operatoros through olm subscription
oc apply -f infra/ocp/operators/subscriptions/elasticsearch-subscription.yaml
oc apply -f infra/ocp/operators/subscriptions/kiali-subscription.yaml
oc apply -f infra/ocp/operators/subscriptions/jaeger-subscription.yaml
oc apply -f infra/ocp/operators/subscriptions/servicemesh-subscription.yaml
oc apply -f infra/ocp/operators/subscriptions/serverless-subscription.yaml

# give it a minute
sleep 60

# wait for operator deployments to complete
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/elasticsearch-operator 
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/jaeger-operator 
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/kiali-operator
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/istio-operator  
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/knative-operator
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/knative-openshift-ingress
kubectl -n openshift-operators wait --for=condition=Available  --timeout=360s deployment.apps/knative-openshift