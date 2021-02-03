export KNATIVE_VERSION="0.19.0"

# Install Knative Serving
kubectl apply --filename "https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-crds.yaml"
kubectl apply --filename "https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-core.yaml"

kubectl label namespace knative-serving istio-injection=enabled

cat <<EOF | kubectl apply -f -
apiVersion: "security.istio.io/v1beta1"
kind: "PeerAuthentication"
metadata:
  name: "default"
  namespace: "knative-serving"
spec:
  mtls:
    mode: PERMISSIVE
EOF

# Configure the magic xip.io DNS name
kubectl apply --filename "https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-default-domain.yaml"

kubectl apply -f "https://raw.githubusercontent.com/knative/serving/master/third_party/istio-latest/net-istio.yaml"