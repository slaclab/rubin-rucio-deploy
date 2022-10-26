#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Please specify the deployment to upload secrets into Vault for (dev|prod)."
    exit -1
fi

if [ $1 == "dev" ]; then
    cd ./secret
    vault kv put secret/rubin/usdf-rucio-dev/rucio usdf-server-hostcert=@dev/hostcert.pem usdf-server-hostkey=@dev/hostkey.pem usdf-server-cafile=@ca.pem
elif [ $1 == "prod" ]; then
    cd ./secret
    vault kv put secret/rubin/usdf-rucio/rucio usdf-server-hostcert=@prod/hostcert.pem usdf-server-hostkey=@prod/hostkey.pem usdf-server-cafile=@ca.pem
else
    echo "Invalid deployment specification. (dev|prod)"
    exit -2
fi
