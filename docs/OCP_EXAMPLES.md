# Examples on Openshift infrastructure

Various examples demonstrating the following: 

- Istio Service Deployment and Validation
- Knative Serving Deployment and Validation
- Knative Eventing Deployment and Validation

## Service Mesh (Istio) - Bookinfo Sample Application

Grab the **Maistra** version of Istio. Do this by cloning the following repository: 

```bash
git clone https://github.com/maistra/istio.git
```

For this example, let us assume that you've cloned this repository to: 

`/tmp/repositories/maistra/istio`

**Maistra** is the RH version of Istio tailored for OpenShift installation. More information about Maistra can be found [here](https://maistra.io/docs/ossm-vs-community.html).

### A Note on Enabling Automatic Sidecar Injection

Sidecar injection in Maistra requires an opt-in. This opt-in is accepted by adding a `sidecar.istio.io/inject` annotation to the configuration YAML with a value of `true`. A more elaborate detail of enabling automatic sidecar injection can be found [here](https://docs.openshift.com/container-platform/4.6/service_mesh/v1x/prepare-to-deploy-applications-ossm.html#ossm-automatic-sidecar-injection_deploying-applications-ossm-v1x). 

### Bookinfo Application Deployment

**(1)** Enable Automatic Sidecar Injection (Optional)

From the cloned Maistra repository, edit the following file: `samples/bookinfo/platform/kube/bookinfo.yaml`, so that you've opted in for accepting sidecar injection by enabling the `sidecar.istio.io/inject` annotation. 

This is already been illustrated in the included example: [`examples/istio/bookinfo/bookinfo.yaml`](/examples/istio/bookinfo/bookinfo.yaml)


**(2)** Deploy Bookinfo Example

From the root of the repository: 

```bash
# switch to the bookinfo project
oc project bookinfo

# deploy the services, service accounts, and deployments for the Bookinfo sample.
oc apply -f examples/istio/bookinfo/bookinfo.yaml

# deploy default gateway and service uri
oc apply -f /tmp/repositories/maistra/istio/samples/bookinfo/networking/bookinfo-gateway.yaml

# deploy default default destination rules
oc apply -f /tmp/repositories/maistra/istio/samples/bookinfo/networking/destination-rule-all.yaml
```

### Validation

## References

https://docs.openshift.com/container-platform/4.6/service_mesh/v1x/prepare-to-deploy-applications-ossm.html#ossm-tutorial-bookinfo-overview_deploying-applications-ossm-v1x