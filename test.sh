apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: allow-from-serving-system-namespace
namespace: testnamespace1
spec:
ingress:
- from:
    - namespaceSelector:
        matchLabels:
        serving.knative.openshift.io/system-namespace: "true"
podSelector: {}
policyTypes:
- Ingress
