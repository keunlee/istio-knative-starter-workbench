mkdir -p tmp/vol

k3d cluster delete istio-kn-starter
k3d cluster create istio-kn-starter --servers 1 --agents 3 --volume $(pwd)/tmp/vol:/tmp/vol --k3s-server-arg --disable=traefik  --wait

kubectx k3d-istio-kn-starter

node_count=$(kubectl get nodes | grep -w 'Ready' | wc -l)
until [ $node_count -eq "4" ]; do
    echo "waiting for node count"
    node_count=$(kubectl get nodes | grep -w 'Ready' | wc -l)
done

kubectl get nodes