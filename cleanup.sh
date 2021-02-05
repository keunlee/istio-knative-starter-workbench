case $1 in
    local)
        sh infra/local/99-cleanup.sh
        ;;
    ocp)
        sh infra/ocp/99-cleanup.sh
        ;;
    *)
        echo "usage: sh cleanup.sh (local|ocp)"
        ;;
esac