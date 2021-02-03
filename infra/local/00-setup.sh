rm -rf tmp

sh infra/local/01-create-cluster.sh
sh infra/local/02-deploy-istio.sh
# sh infra/local/03-deploy-knative.sh