#!/bin/bash

# FTS3 Delegation Secrets
kubectl -n rucio create secret generic usdf-rucio-fts-cert \
        --from-file=usercert.pem=${PWD}/secret/hostcert.pem \

kubectl -n rucio create secret generic usdf-rucio-fts-key \
	--from-file=new_userkey.pem=${PWD}/secret/hostkey.pem

# Daemon Secrets
kubectl -n rucio create secret generic usdf-rucio-x509up \
        --from-file=hostcert.pem=${PWD}/secret/hostcert.pem \
        --from-file=hostkey.pem=${PWD}/secret/hostkey.pem

kubectl -n rucio create secret generic usdf-rucio-ca-bundle \
        --from-file=ca.pem=${PWD}/secret/ca.pem

# Ingress Secrets
kubectl -n rucio create secret tls rucio-server.tls-secret \
        --cert=${PWD}/secret/hostcert.pem \
        --key=${PWD}/secret/hostkey.pem

# Reapers need the whole directory of certificates
mkdir /tmp/reaper-certs
cp /etc/grid-security/certificates/*.0 /tmp/reaper-certs/
cp /etc/grid-security/certificates/*.signing_policy /tmp/reaper-certs/
kubectl -n rucio create secret generic usdf-rucio-ca-bundle-reaper \
        --from-file=/tmp/reaper-certs
rm -r /tmp/reaper-certs

# WebUI
kubectl -n rucio create secret generic usdf-hostcert \
        --from-file=hostcert.pem=${PWD}/secret/hostcert.pem

kubectl -n rucio create secret generic usdf-hostkey \
        --from-file=hostkey.pem=${PWD}/secret/hostkey.pem

kubectl -n rucio create secret generic usdf-cafile \
        --from-file=ca.pem=${PWD}/secret/ca.pem
