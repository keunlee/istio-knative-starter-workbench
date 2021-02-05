# Preparing the Cluster - Local Infrastructure

This setup makes a rather opinionated choice for you in determining what to run locally as your Kubernetes cluster. For our cluster, we will be leveraging Rancher's [K3D v4.0.0](https://k3d.io/), hence the scripts and instructions will be tailored for our local infrastructure. 

You can also try to leverage other options that suit your fancy such as, but not limited to, the following: 

- [Kind](https://kind.sigs.k8s.io/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [MicroK8s](https://microk8s.io/)

Just keep in mind, this workbench does not leverage any of those options. 

## Pre-requisites

Make sure the following tools are installed and available on your `PATH` environment variable. 

- [oc cli](https://developers.redhat.com/openshift/command-line-tools)
- [kn (Knative CLI)](https://knative.dev/docs/install/install-kn/)
- [jq](https://stedolan.github.io/jq/)
- git

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
│   └── local
│       ├── 00-setup.sh
│       ├── 01-create-cluster.sh
│       ├── 02-deploy-istio.sh
│       └── 03-deploy-knative.sh
└── setup.sh
```

### Script Execution

To execute the creation of your environment, from the root of the repository: 

```bash
sh setup.sh local
```

The script will take several minutes to execute. When completed successfully, you will have a cluster running Istio and Knative which you will be able to develop off of and/or run examples. 

### Clean Up

To clean up and completely wipe away your workbench, from the root of the repository: 

```bash
sh cleanup.sh local
```

