#!/bin/bash

# Daemon Secrets
kubectl create secret generic usdf-rucio-x509up \
        --from-file=hostcert.pem=${PWD}/secret/rubin-rucio.slac.stanford.edu-cert.pem \
        --from-file=hostkey.pem=${PWD}/secret/rubin-rucio.slac.stanford.edu-key.pem

kubectl create secret generic usdf-rucio-ca-bundle \
        --from-file=ca.pem.pem=${PWD}/secret/ca_bundle.pem

# Ingress Secrets
kubectl create secret tls rucio-server.tls-secret \
        --cert=${PWD}/secret/rubin-rucio.slac.stanford.edu-cert.pem \
        --key=${PWD}/secret/rubin-rucio.slac.stanford.edu-key.pem
