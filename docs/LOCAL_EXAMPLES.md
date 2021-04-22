# Examples on Openshift infrastructure

Various examples demonstrating the following: 

- Istio Service Deployment and Validation
- Knative Serving Deployment and Validation
- Knative Eventing Deployment and Validation

## Pre-requisites

Make sure the following tools are installed and available on your `PATH` environment variable. 

- [hey](https://github.com/rakyll/hey)

## I. Service Mesh (Istio) - Bookinfo Sample Application

Grab the upstream version of Istio, if you do not have it already. Do this by cloning the following repository:

```bash
git clone https://github.com/istio/istio.git tmp/repositories/istio
```

For this example, let us assume that you've cloned this repository to the root of this repository to the following relative path: 

`tmp/repositories/istio`

### Bookinfo Application Deployment

**(2)** Deploy Bookinfo Example

From the root of the repository: 

```bash
# create the bookinfo namespace
kubectl create ns bookinfo

# enable automatic sidecar injection
kubectl label namespace bookinfo istio-injection=enabled

# switch to the bookinfo project
kubens bookinfo

# deploy the services, service accounts, and deployments for the Bookinfo sample.
kubectl apply -f tmp/repositories/istio/samples/bookinfo/platform/kube/bookinfo.yaml

# deploy default gateway and service uri
kubectl apply -f tmp/repositories/istio/samples/bookinfo/networking/bookinfo-gateway.yaml

# deploy default destination rules
kubectl apply -f tmp/repositories/istio/samples/bookinfo/networking/destination-rule-all.yaml
```

**(3)** View Bookinfo Application

```bash
# obtain the ingress host
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')

# obtain the ingress port
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')

# obtain the bookinfo productpage url
export BOOKINFO_URI=http://$INGRESS_HOST:$INGRESS_PORT/productpage

# print the bookinfo productpage url
echo $BOOKINFO_URI
```

Navigate to the output of the "echo" statement, which will be the bookinfo productpage, and should look like the following: 

![Screenshot from 2021-02-09 22-53-08](https://user-images.githubusercontent.com/61749/107466459-ab7f2600-6b29-11eb-9c3a-ecbc53945d48.png)

### Validation

To validate our service mesh, we will be leveraging [Kiali](https://kiali.io/) and a load generating CLI tool called [hey](https://github.com/rakyll/hey)

**(1)** Open Kiali

From a second terminal window: 

```bash
# create a localhost proxy to the kiali host
# it will be accessible at: http://localhost:20001/kiali
# ctrl-c to terminate the proxy
istioctl dashboard kiali
```

Navigate to the location of Kiali. 

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
kubectl apply -f tmp/repositories/istio/samples/bookinfo/networking/virtual-service-all-v1.yaml

# create traffic
hey -z 15s -c 10 $BOOKINFO_URI
```

Observe the network traffic in Kiali

![Screenshot from 2021-02-09 23-48-31](https://user-images.githubusercontent.com/61749/107470655-5c3cf380-6b31-11eb-8269-5a2841071d26.png)

**(3)** Split network traffic 80-20 between version v1 and v2 for the "reviews" service. 

```bash
# update the network traffic rules
kubectl apply -f tmp/istio/samples/bookinfo/networking/virtual-service-reviews-80-20.yaml

# create traffic
hey -z 15s -c 10 $BOOKINFO_URI
```

Observe the network traffic in Kiali

![Screenshot from 2021-02-09 23-53-03](https://user-images.githubusercontent.com/61749/107471003-fa30be00-6b31-11eb-9f8c-331ac0c382ab.png)