# Istio + Knative Starter Workbench

This workbench project details the procedures to get you setup and running Istio and Knative on a cluster, for local and openshift infrastructures. 

In addition to setup, this workbench also details various examples to demonstrate the usage of Istio and Knative

# Local Infrastructure using K3D

## [Preparing the Cluster - Local Infrastructure](docs/LOCAL_SETUP.md)

Instructions and scripts for putting together a local development environment, detailing the following: 

- Creating a local development cluster
- Deploying and configuring Istio
- Deploying and configuraing Knative

## [Running the Examples on Local infrastructure](docs/OCP_EXAMPLES.md)

Various examples demonstrating the following: 

- Istio Service Deployment and Validation
- Knative Serving Deployment and Validation
- Knative Eventing Deployment and Validation

# Openshift 4.x Infrastructure

## [Preparing the Cluster - Openshift Infrastructure](docs/OCP_SETUP.md)

Instructions tailored for Openshift 4.6.x: 

- Deploying and configuring Istio
- Deploying and configuraing Knative

## [Running the Examples on Openshift infrastructure](docs/LOCAL_EXAMPLES.md)

Various examples demonstrating the following: 

- Istio Service Deployment and Validation
- Knative Serving Deployment and Validation
- Knative Eventing Deployment and Validation