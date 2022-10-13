#!/bin/bash
#
# get the secrets from vault
mkdir -p ./etc/.secrets/
# user input the kubernetes namespace(usdf-rucio-dev or usdf-rucio) in the commandline
SECRET_PATH=secret/rubin/$1/rucio
set -e
#
for i in "usdf-server-hostkey" "usdf-server-hostcert" "usdf-server-cafile"; do
    echo "$i"
    if [ "$i" = "usdf-server-hostkey" ]; then
        vault kv get --field=$i $SECRET_PATH  > etc/.secrets/hostkey.pem
    elif [ "$i" = "usdf-server-hostcert" ]; then
        vault kv get --field=$i $SECRET_PATH  > etc/.secrets/hostcert.pem
    elif [ "$i" = "usdf-server-cafile" ]; then
        vault kv get --field=$i $SECRET_PATH  > etc/.secrets/ca.pem
    else
       echo "Wrong valut key."
       exit 1
    fi
done

# Server
kubectl -n rucio create secret generic usdf-server-hostcert \
        --from-file=hostcert.pem=${PWD}/etc/.secrets/hostcert.pem

kubectl -n rucio create secret generic usdf-server-hostkey \
        --from-file=hostkey.pem=${PWD}/etc/.secrets/hostkey.pem

kubectl -n rucio create secret generic usdf-server-cafile \
        --from-file=ca.pem=${PWD}/etc/.secrets/ca.pem

# Auth Server
kubectl -n rucio create secret generic usdf-auth-hostcert \
        --from-file=hostcert.pem=${PWD}/etc/.secrets/hostcert.pem

kubectl -n rucio create secret generic usdf-auth-hostkey \
        --from-file=hostkey.pem=${PWD}/etc/.secrets/hostkey.pem

kubectl -n rucio create secret generic usdf-auth-cafile \
        --from-file=ca.pem=${PWD}/etc/.secrets/ca.pem

# FTS3 Delegation Secrets
kubectl -n rucio create secret generic usdf-rucio-fts-cert \
        --from-file=usercert.pem=${PWD}/etc/.secrets/hostcert.pem \

kubectl -n rucio create secret generic usdf-rucio-fts-key \
	--from-file=new_userkey.pem=${PWD}/etc/.secrets/hostkey.pem

# Daemon Secrets
kubectl -n rucio create secret generic usdf-rucio-x509up \
        --from-file=hostcert.pem=${PWD}/etc/.secrets/hostcert.pem \
        --from-file=hostkey.pem=${PWD}/etc/.secrets/hostkey.pem

kubectl -n rucio create secret generic usdf-rucio-ca-bundle \
        --from-file=ca.pem=${PWD}/etc/.secrets/ca.pem

# Ingress Secrets
kubectl -n rucio create secret tls rucio-server.tls-secret \
        --cert=${PWD}/etc/.secrets/hostcert.pem \
        --key=${PWD}/etc/.secrets/hostkey.pem

# Reapers need the whole directory of certificates
mkdir /tmp/reaper-certs
cp /etc/grid-security/certificates/*.0 /tmp/reaper-certs/
cp /etc/grid-security/certificates/*.signing_policy /tmp/reaper-certs/
kubectl -n rucio create secret generic usdf-rucio-ca-bundle-reaper \
        --from-file=/tmp/reaper-certs
rm -r /tmp/reaper-certs

# WebUI
kubectl -n rucio create secret generic usdf-hostcert \
        --from-file=hostcert.pem=${PWD}/etc/.secrets/hostcert.pem

kubectl -n rucio create secret generic usdf-hostkey \
        --from-file=hostkey.pem=${PWD}/etc/.secrets/hostkey.pem

kubectl -n rucio create secret generic usdf-cafile \
        --from-file=ca.pem=${PWD}/etc/.secrets/ca.pem

# FTS3
kubectl -n rucio create secret generic usdf-fts-cert \
        --from-file=usercert.pem=${PWD}/etc/.secrets/hostcert.pem

kubectl -n rucio create secret generic usdf-fts-key \
        --from-file=new_userkey.pem=${PWD}/etc/.secrets/hostkey.pem
#remove the secrets
rm -rf ${PWD}/etc/.secrets/
