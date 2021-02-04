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