# create knative-serving namespace
oc new-project knative-serving

# deploy knative service
oc apply -f infra/ocp/operators/crd-instances/serverless/knative-serving.yaml

sleep 120

# wait for knative deployments to deploy
kubectl -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/activator
kubectl -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/autoscaler
kubectl -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/autoscaler-hpa     
kubectl -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/controller
kubectl -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/webhook

# Create a network policy that permits traffic flow from Knative system Pods to Knative service
oc label namespace knative-serving serving.knative.openshift.io/system-namespace=true
oc label namespace knative-serving-ingress serving.knative.openshift.io/system-namespace=true

# allows ksvc networking on a specific namespace
function enable_ksvc_on_namespace() {
cat <<EOF | oc apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-serving-system-namespace
  namespace: $1
spec:
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          serving.knative.openshift.io/system-namespace: "true"
  podSelector: {}
  policyTypes:
  - Ingress
EOF
}

# enable ksvc networking on a specific namespace
enable_ksvc_on_namespace "knative-sandbox"

