#!/bin/bash
set -e

export_base="/root"

### Handle `docker stop` for graceful shutdown
function shutdown_nfs {
    echo "- Shutting down nfs-server.."
    service nfs-kernel-server stop
    echo "- Nfs server is down"
    exit 0
}

trap "shutdown_nfs" SIGTERM

function shutdown_ssh {
    echo "- Shutting down SSH server.."
    service ssh stop
    echo "- Nfs server is down"
    exit 0
}

trap "shutdown_ssh" SIGTERM
####


echo "Export points:"
echo "$export_base *(rw,sync,insecure,fsid=0,no_subtree_check,no_root_squash)" | tee /etc/exports

read -a exports <<< "${@}"
for export in "${exports[@]}"; do
    src=`echo "$export" | sed 's/^\///'` # trim the first '/' if given in export path
    src="$export_base$src"
    mkdir -p $src
    chmod 777 $src
    echo "$src *(rw,sync,insecure,no_subtree_check,no_root_squash)" | tee -a /etc/exports
done

echo -e "\n- Initializing NFS server.."
rpcbind
service nfs-kernel-server start
echo "- NFS server is up and running.."

echo -e "\n- Initializing SSH server.."
service ssh start
echo "- SSH server is up and running.."


## Run until signaled to stop...
while :
do
    sleep 1  # Interupt interval time
done
