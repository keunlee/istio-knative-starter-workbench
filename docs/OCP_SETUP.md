# Preparing the Cluster - Openshift Infrastructure

This setup leverages Operators from the Openshift Operatorhub to deploy an instance of Istio and Knative as well additionals to help you monitor your infrastructure.

## Disclaimer 

These setup instructions are intended for non-production environments. 

## Pre-requisites

An accessible Openshift Cluster **>= v4.7.x**

Administrative access to the cluster - full access (i.e. admin)

Make sure the following tools are installed and available on your `PATH` environment variable. 
- [oc cli](https://developers.redhat.com/openshift/command-line-tools)
- [kn (Knative CLI)](https://knative.dev/docs/install/install-kn/)
- [jq](https://stedolan.github.io/jq/)
- git

Make sure the following operators are NOT already installed in the `openshift-operators` namespace/project: 

- "serverless-operator"
- "servicemeshoperator"
- "kiali-ossm"
- "jaeger-product"
- "elasticsearch-operator"

## Installation

### Overview

To assist in the creation of your local workbench, there is a "setup" routine made available for convenience. These scripts accomplish the following tasks: 

- Install the following Operators from Openshift OperatorHub
    - Elasticsearch Operator
    - Kiali Operator
    - Jaeger Operator
    - Red Hat Service Mesh Operator
    - Red Hat Serverless Operator
- Deploy and configure Openshift Service Mesh (Istio)
- Deploy and configure Openshift Serverless (Knative)

Please review and examine the following scripts to understand what they are and what they do. 

```
root
├── cleanup.sh
├── infra
│   └── ocp
│       ├── 00-setup.sh
│       ├── 01-setup-operator-subscriptions.sh
│       ├── 02-deploy-openshift-service-mesh.sh
│       ├── 03-deploy-openshift-serverless.sh
│       ├── 99-cleanup.sh
│       └── operators
│           ├── crd-instances
│           │   ├── serverless
│           │   │   └── knative-serving.yaml
│           │   └── service-mesh
│           │       ├── service-mesh-control-plane.yaml
│           │       └── service-mesh-member-roll.yaml
│           └── subscriptions
│               ├── elasticsearch-subscription.yaml
│               ├── jaeger-subscription.yaml
│               ├── kiali-subscription.yaml
│               ├── serverless-subscription.yaml
│               └── servicemesh-subscription.yaml
└── setup.sh
```

### Login to Openshift (oc CLI)

Login to the cluster using the `oc` cli tool. Do this before executing any of the scripts. 

Make sure the user you are logging in as has administrative privileges.

If using username/password:

```bash
oc login -u admin -p <your-password>
```

If using a token you've obtained from the openshift console: 

```bash
 oc login --token=1o7R7SWQvYagcngvromOwGCbyN844EJs-NjWfmfSKJo --server=https://my-ocp-cluster:6443
```

### Script Execution

To execute the creation of your environment, from the root of the repository: 

```bash
sh setup.sh ocp
```

The script will take several minutes to execute. When completed successfully, you will have a cluster running Istio and Knative which you will be able to develop off of and/or run examples. 

### Clean Up

This clean up procedure will do the following in respective order: 

- purge all resources in the `bookinfo` namespace
- purge all resources in the `knative-sandbox` namespace
- purge all resources in the `knative-serving` namespace
- purge all resources in the `istio-system` namespace
- delete the aformentioned namespaces/projects
- uninstall and delete the following operator subscriptions: 
    - "serverless-operator"
    - "servicemeshoperator"
    - "kiali-ossm"
    - "jaeger-product"
    - "elasticsearch-operator"

To clean up and completely wipe away your workbench, from the root of the repository: 

```bash
sh cleanup.sh ocp
```

