oc new-project knative-serving

oc apply -f infra/ocp/operators/crd-instances/serverless/knative-serving.yaml

sleep 120

# NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/activator                 2/2     2            2           5m27s
# deployment.apps/autoscaler                1/1     1            1           5m26s
# deployment.apps/autoscaler-hpa            2/2     2            2           5m22s
# deployment.apps/controller                2/2     2            2           5m26s
# deployment.apps/kn-cli-2gls9-deployment   1/1     1            1           4m46s
# deployment.apps/webhook                   1/1     1            1           5m25s

# Create a network policy that permits traffic flow from Knative system Pods to Knative service
oc label namespace knative-serving serving.knative.openshift.io/system-namespace=true
oc label namespace knative-serving-ingress serving.knative.openshift.io/system-namespace=true
