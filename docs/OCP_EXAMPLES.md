# Examples on Openshift infrastructure

Various examples demonstrating the following: 

- Istio Service Deployment and Validation
- Knative Serving Deployment and Validation
- Knative Eventing Deployment and Validation

## Pre-requisites

Make sure the following tools are installed and available on your `PATH` environment variable. 

- [hey](https://github.com/rakyll/hey)

## I. Service Mesh (Istio) - Bookinfo Sample Application

Grab the **Maistra** version of Istio. Do this by cloning the following repository:

```bash
git clone https://github.com/maistra/istio.git tmp/repositories/maistra/istio
```

For this example, let us assume that you've cloned this repository to the root of this repository to the following relative path: 

`tmp/repositories/maistra/istio`

**Maistra** is the RH version of Istio tailored for OpenShift installation. More information about Maistra can be found [here](https://maistra.io/docs/ossm-vs-community.html).

### A Note on Enabling Automatic Sidecar Injection

Sidecar injection in Maistra requires an opt-in. This opt-in is accepted by adding a `sidecar.istio.io/inject` annotation to the configuration YAML with a value of `true`. A more elaborate detail of enabling automatic sidecar injection can be found [here](https://docs.openshift.com/container-platform/4.6/service_mesh/v1x/prepare-to-deploy-applications-ossm.html#ossm-automatic-sidecar-injection_deploying-applications-ossm-v1x). 

### Bookinfo Application Deployment

**(1)** Enable Automatic Sidecar Injection

From the cloned Maistra Istio repository, edit the following file: `samples/bookinfo/platform/kube/bookinfo.yaml`, so that you've opted in for accepting sidecar injection by enabling the `sidecar.istio.io/inject` annotation. 

TL;DR This has already been illustrated in the included example: [`examples/istio/bookinfo/bookinfo.yaml`](/examples/istio/bookinfo/bookinfo.yaml). 


**(2)** Deploy Bookinfo Example

From the root of the repository: 

```bash
# switch to the bookinfo project
oc project bookinfo

# deploy the services, service accounts, and deployments for the Bookinfo sample.
oc apply -f examples/istio/bookinfo/bookinfo.yaml

# deploy default gateway and service uri
oc apply -f tmp/repositories/maistra/istio/samples/bookinfo/networking/bookinfo-gateway.yaml

# deploy default destination rules
oc apply -f tmp/repositories/maistra/istio/samples/bookinfo/networking/destination-rule-all.yaml
```

**(3)** View Bookinfo Application

```bash
# obtain the bookinfo application host
# i.e. bookinfo-bookinfo-gateway-vgns2-istio-system.apps.private-cluster.local
BOOKINFO_HOST=$(oc get routes -n istio-system -l maistra.io/gateway-name=bookinfo-gateway -o jsonpath='{..status.ingress[0].host}')

BOOKINFO_URI=http://$BOOKINFO_HOST/productpage

# print the bookinfo productpage url
# i.e. http://bookinfo-bookinfo-gateway-vgns2-istio-system.apps.private-cluster.local/productpage
echo $BOOKINFO_URI
```

Navigate to the output of the "echo" statement, which will be the bookinfo productpage, and should look like the following: 

![Screenshot from 2021-02-09 22-53-08](https://user-images.githubusercontent.com/61749/107466459-ab7f2600-6b29-11eb-9c3a-ecbc53945d48.png)

### Validation

To validate our service mesh, we will be leveraging [Kiali](https://kiali.io/) and a load generating CLI tool called [hey](https://github.com/rakyll/hey)

**(1)** Open Kiali

```bash
# obtain the kiali host 
# i.e. https://kiali-istio-system.apps.private-cluster.local/
KIALI_URI=https://$(oc get routes -n istio-system -l app=kiali -o jsonpath='{..status.ingress[0].host}')

echo $KIALI_URI
```

Navigate to the output of the "echo" statement, which will be the location of Kiali. 

Select "Graph" from the left menu. 

Select "bookinfo" in the Namespace dropdown

From the "Display" dropdown: 
- Select "Requests Percentage"
- Check "Traffic Animation"
- Leave all other selections as is

Your selections should look similar to the following: 

![Screenshot from 2021-02-09 23-38-35](https://user-images.githubusercontent.com/61749/107469778-ff8d0900-6b2f-11eb-829a-bff81cc29079.png)

**(2)** Use version v1 of all deployed services

```bash
# update the network traffic rules
oc apply -f tmp/maistra/istio/samples/bookinfo/networking/virtual-service-all-v1.yaml

# create traffic
hey -z 15s -c 10 $BOOKINFO_URI
```

Observe the network traffic in Kiali

![Screenshot from 2021-02-09 23-48-31](https://user-images.githubusercontent.com/61749/107470655-5c3cf380-6b31-11eb-8269-5a2841071d26.png)

**(3)** Split network traffic 80-20 between version v1 and v2 for the "reviews" service. 

```bash
# update the network traffic rules
oc apply -f tmp/maistra/istio/samples/bookinfo/networking/virtual-service-reviews-80-20.yaml

# create traffic
hey -z 15s -c 10 $BOOKINFO_URI
```

Observe the network traffic in Kiali

![Screenshot from 2021-02-09 23-53-03](https://user-images.githubusercontent.com/61749/107471003-fa30be00-6b31-11eb-9f8c-331ac0c382ab.png)


## References

https://docs.openshift.com/container-platform/4.6/service_mesh/v1x/prepare-to-deploy-applications-ossm.html#ossm-tutorial-bookinfo-overview_deploying-applications-ossm-v1x