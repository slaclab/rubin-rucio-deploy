SERVER_CHART_VERSION := 38.0.3
DAEMON_CHART_VERSION := 38.0.2
UI_CHART_VERSION := 35.1.0

helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update rucio

rucio-server: helm
	helm template usdf rucio/rucio-server --namespace rucio --version=${SERVER_CHART_VERSION} --values=rucio/values-rucio-server.yaml > rucio/helm-rucio-server.yaml

rucio-daemons: helm
	helm template usdf rucio/rucio-daemons --namespace rucio --version=${DAEMON_CHART_VERSION} --values=rucio/values-rucio-daemons.yaml > rucio/helm-rucio-daemons.yaml

rucio-ui: helm
	helm template usdf rucio/rucio-webui --namespace rucio --version=${UI_CHART_VERSION} --values=rucio/values-rucio-ui.yaml > rucio/helm-rucio-ui.yaml

rucio: rucio-server rucio-daemons rucio-ui

get-secrets:
	mkdir -p rucio/etc/.secrets
	vault kv get --field=usdf-server-hostkey secret/rubin/usdf-rucio-dev/rucio  > rucio/etc/.secrets/hostkey.pem
	vault kv get --field=usdf-server-hostcert secret/rubin/usdf-rucio-dev/rucio  > rucio/etc/.secrets/hostcert.pem
	vault kv get --field=usdf-server-cafile secret/rubin/usdf-rucio-dev/rucio  > rucio/etc/.secrets/ca.pem
	vault kv get --field=usdf-db-conn-str secret/rubin/usdf-rucio-dev/rucio  > rucio/etc/.secrets/db-conn-str.txt
	vault kv get --field=usdf-elasticsearch-password secret/rubin/usdf-rucio-dev/rucio  > rucio/etc/.secrets/usdf-elasticsearch-password
	cp rucio/etc/automatix.json rucio/etc/.secrets/automatix.json
#	mkdir -p postgres/etc/.secrets
#	vault kv get --field=client-secret secret/rubin/usdf-rucio-dev/s3  > postgres/etc/.secrets/client-secret
#	vault kv get --field=client-id secret/rubin/usdf-rucio-dev/s3  > postgres/etc/.secrets/client-id
#	vault kv get --field=username secret/rubin/usdf-rucio-dev/database  > postgres/etc/.secrets/username
#	vault kv get --field=password secret/rubin/usdf-rucio-dev/database  > postgres/etc/.secrets/password
	mkdir -p data-backbone/redis/etc/.secrets
	vault kv get --field=redis secret/rubin/usdf-rucio-dev/data-backbone > data-backbone/redis/etc/.secrets/redis-secret

clean-secrets:
	rm -rf rucio/etc/.secrets postgres/etc/.secrets data-backbone/redis/etc/.secrets

run-dump: 
	kubectl kustomize .

dump: get-secrets rucio run-dump clean-secrets 

run-apply:  
	kubectl config use-context "usdf-rucio-dev"
	kubectl apply -k .

apply: get-secrets rucio run-apply clean-secrets 

run-destroy:
	kubectl delete -k .

destroy: get-secrets rucio run-destroy clean-secrets 
