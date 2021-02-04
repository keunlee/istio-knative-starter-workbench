function wait_for_zero_resource_count() {
    project_resource_count=$(oc get all -o json | jq -r '.items' | jq length)
    until [ $project_resource_count -eq "0" ]; do
        echo "waiting for resources to be purged"
        project_resource_count=$(oc get all -o json | jq -r '.items' | jq length)
        sleep 5
    done    
}

# delete knative serving instances, resources, and projects
oc project knative-serving
oc delete po -l app=storage-version-migration
oc delete -f infra/ocp/operators/crd-instances/serverless/knative-serving.yaml

wait_for_zero_resource_count

# delete service mesh crd instances, resources, and projects
oc project istio-system
oc delete -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-member-roll.yaml
oc delete -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-control-plane.yaml

wait_for_zero_resource_count

oc delete project bookinfo
oc delete project knative-sandbox
oc delete project knative-serving
oc delete project istio-system

# remove operators

function get_operator_csv() {
    oc get subscription $1 -n openshift-operators -o yaml | grep -i currentCSV | sed -e 's/^[ \t]*//' |  sed 's/^currentCSV://' |  sed -e 's/^[ \t]*//'
}

value=$(get_operator_csv "serverless-operator ")
oc delete subscription serverless-operator  -n openshift-operators
oc delete clusterserviceversion $value -n openshift-operators

value=$(get_operator_csv "servicemeshoperator ")
oc delete subscription servicemeshoperator  -n openshift-operators
oc delete clusterserviceversion $value -n openshift-operators

value=$(get_operator_csv "kiali-ossm")
oc delete subscription kiali-ossm -n openshift-operators
oc delete clusterserviceversion $value -n openshift-operators

value=$(get_operator_csv "jaeger-product")
oc delete subscription jaeger-product -n openshift-operators
oc delete clusterserviceversion $value -n openshift-operators

value=$(get_operator_csv "elasticsearch-operator")
oc delete subscription elasticsearch-operator -n openshift-operators
oc delete clusterserviceversion $value -n openshift-operators

oc delete service maistra-admission-controller -n openshift-operators
oc delete service admission-server-service -n openshift-operators
oc delete daemonsets.apps istio-node -n openshift-operators
