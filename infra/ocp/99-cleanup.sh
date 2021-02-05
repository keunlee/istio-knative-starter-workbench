# this function retrieves an operator's 'currentCSV' field value
# necessary for identifying the installed operator and it's version
function get_operator_csv() {
    oc get subscription $1 -n openshift-operators -o yaml | grep -i currentCSV | sed -e 's/^[ \t]*//' |  sed 's/^currentCSV://' |  sed -e 's/^[ \t]*//'
}

# this function is a wait method which breaks when the number of resources in a namespace has reached zero
# useful for waitig on resources to terminate from a namespace, when clearing out a namespace
function wait_for_zero_resource_count() {
    iter=20
    project_resource_count=$(oc get all -o json | jq -r '.items' | jq length)
    until [ $project_resource_count -eq "0" ]; do
        echo "waiting for resources to be purged"
        project_resource_count=$(oc get all -o json | jq -r '.items' | jq length)
        sleep 5

        ((iter--))
        if [[ $iter -eq 0 ]]; then
            break
        fi
    done    
}

# delete knative serving instances, resources, and projects
project_namespace=$(oc get project knative-serving --ignore-not-found)
if [ -z "$project_namespace" ]
then
    echo "$project_namespace does not exist"
else
    oc project knative-serving
    oc delete po -l app=storage-version-migration
    oc delete -f infra/ocp/operators/crd-instances/serverless/knative-serving.yaml

    wait_for_zero_resource_count
fi

# delete service mesh crd instances, resources, and projects
project_namespace=$(oc get project istio-system --ignore-not-found)
if [ -z "$project_namespace" ]
then
    echo "$project_namespace does not exist"
else
    oc project istio-system
    oc delete -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-member-roll.yaml
    oc delete -f infra/ocp/operators/crd-instances/service-mesh/service-mesh-control-plane.yaml

    wait_for_zero_resource_count
fi

# delete unused namespaces/projects
oc delete project bookinfo
oc delete project knative-sandbox
oc delete project knative-serving
oc delete project istio-system

# remove the operators we installed earlier
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
