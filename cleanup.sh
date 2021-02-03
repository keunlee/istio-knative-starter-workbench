case $1 in
    local)
        k3d cluster delete istio-kn-starter
        rm -rf tmp
        ;;
    ocp)
        ;;
    *)
        echo "usage: sh cleanup.sh (local|ocp)"
        ;;
esac