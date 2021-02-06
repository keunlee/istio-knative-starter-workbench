# this function allows ksvc networking on a specific namespace
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

# create knative-serving namespace
oc new-project knative-serving

# wait a minute for the project to initialize
sleep 10

# deploy knative service
oc apply -f infra/ocp/operators/crd-instances/serverless/knative-serving.yaml

# wait a few
sleep 120

# wait for knative deployments to deploy
oc -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/activator
oc -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/autoscaler
oc -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/autoscaler-hpa     
oc -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/controller
oc -n knative-serving wait --for=condition=Available  --timeout=360s deployment.apps/webhook

# Create a network policy that permits traffic flow from Knative system Pods to Knative service
oc label namespace knative-serving serving.knative.openshift.io/system-namespace=true
oc label namespace knative-serving-ingress serving.knative.openshift.io/system-namespace=true

# enable ksvc networking on a specific namespace
enable_ksvc_on_namespace "knative-sandbox"

