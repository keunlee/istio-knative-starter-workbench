# Preparing the Cluster - Local Infrastructure

This setup makes a rather opinionated choice for you in determining what to run locally as your Kubernetes cluster. For our cluster, we will be leveraging Rancher's [K3D v4.0.0](https://k3d.io/), hence the scripts and instructions will be tailored for our local infrastructure. 

You can also try to leverage other options that suit your fancy such as, but not limited to, the following: 

- [Kind](https://kind.sigs.k8s.io/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [MicroK8s](https://microk8s.io/)

Just keep in mind, this workbench does not leverage any of those options. 

## Pre-requisites

Make sure the following tools are installed and available on your `PATH` environment variable. 

- [docker](https://docs.docker.com/get-docker/)
- [K3D v4.0.0](https://k3d.io/) 
- [kubens/kubectx](https://github.com/ahmetb/kubectx)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [istioctl](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/)
- [kn (Knative CLI)](https://knative.dev/docs/install/install-kn/)
- Common Linux based CLI tools: `sed,grep,watch,cat, etc.`

## 