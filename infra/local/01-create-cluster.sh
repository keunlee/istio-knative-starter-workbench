# create a directory for local cluster persistent storage
mkdir -p tmp/vol

# delete previous cluster if exists
k3d cluster delete istio-kn-starter

# create new cluster
k3d cluster create istio-kn-starter --servers 1 --agents 3 --volume $(pwd)/tmp/vol:/tmp/vol --k3s-server-arg --disable=traefik  --wait

# activate the cluster into your current kubectl context
kubectx k3d-istio-kn-starter

# wait until all nodes are up and ready
node_count=$(kubectl get nodes | grep -w 'Ready' | wc -l)
until [ $node_count -eq "4" ]; do
    echo "waiting for node count"
    node_count=$(kubectl get nodes | grep -w 'Ready' | wc -l)
done

# print out the nodes
kubectl get nodes