#!/bin/bash
cd ./rubin-rucio-dev-secrets	
vault kv put secret/rubin/usdf-rucio-dev/rucio usdf-server-hostcert=@hostcert.pem usdf-server-hostkey=@hostkey.pem usdf-server-cafile=@ca.pem
