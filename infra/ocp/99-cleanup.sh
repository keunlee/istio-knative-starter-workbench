# this function retrieves an operator's 'currentCSV' field value
# necessary for identifying the installed operator and it's version
function get_operator_csv() {
    oc get subscriptions.operators.coreos.com $1 -n openshift-operators -o yaml | grep -i currentCSV | sed -e 's/^[ \t]*//' |  sed 's/^currentCSV://' |  sed -e 's/^[ \t]*//'
}

# this function uninstalls a specified operator
function uninstall_operator() {
    value=$(get_operator_csv $1)
    oc delete subscriptions.operators.coreos.com $1 -n openshift-operators
    oc delete clusterserviceversion $value -n openshift-operators    
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

# this function purges all resources, including CRD instances, in a namespace
function purge_namespace() {
    project_status=$(oc get project $1 --ignore-not-found)
    if [ -z "$project_status" ]
    then
        echo "$1 does not exist"
    else
        oc project $1
        oc delete ksvc --all
        oc delete "$(oc api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all
        wait_for_zero_resource_count
    fi
}

# delete bookinfo resources
purge_namespace "bookinfo"

# delete sandbox resources
purge_namespace "knative-sandbox"

# delete knative serving instances and resources
project_status=$(oc get project knative-serving --ignore-not-found)
if [ -z "$project_status" ]
then
    echo "knative-serving does not exist"
else
    oc project knative-serving
    oc delete ingresses.networking.internal.knative.dev kn-cli
    oc delete knativeservings.operator.knative.dev knative-serving
    oc delete po -l app=storage-version-migration
    wait_for_zero_resource_count
fi

# delete service mesh crd instances and resources
project_status=$(oc get project istio-system --ignore-not-found)
if [ -z "$project_status" ]
then
    echo "istio-system does not exist"
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
oc project openshift-operators

uninstall_operator "serverless-operator"
uninstall_operator "servicemeshoperator"
uninstall_operator "kiali-ossm"
uninstall_operator "jaeger-product"
uninstall_operator "elasticsearch-operator"

oc delete service maistra-admission-controller -n openshift-operators
oc delete service admission-server-service -n openshift-operators
oc delete daemonsets.apps istio-node -n openshift-operators
