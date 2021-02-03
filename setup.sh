# sh infra/local/00-setup.sh

case $1 in
    local)
        sh infra/local/00-setup.sh
        ;;
    ocp)
        sh infra/ocp/00-setup.sh
        ;;
    *)
        echo "usage: sh setup.sh (local|ocp)"
        ;;

esac