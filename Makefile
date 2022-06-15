SECRET_PATH=secret/rubin/usdf-rucio--dev/rucio

helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update

rucio-server: helm
	helm template usdf rucio/rucio-server --values=values-rucio-server.yaml > helm-rucio-server.yaml

rucio-daemons: helm
	helm template usdf rucio/rucio-daemons --values=values-rucio-daemons.yaml > helm-rucio-daemons.yaml

rucio-ui: helm
	helm template usdf rucio/rucio-ui --values=values-rucio-ui.yaml > helm-rucio-ui.yaml

rucio: rucio-server rucio-daemons rucio-ui

postgres-operator:
	git submodule add https://github.com/zalando/postgres-operator.git zalando-postgres-operator/deps/postgres-operator || true
	cd zalando-postgres-operator/deps/postgres-operator && git pull

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	# use kustomize and add a secretGenerator from these files
	# TODO alternative is to create a vault secrets vault-secrets-operator
	set -e; for i in blah; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -rf etc/.secrets/

run-apply: postgres-operator
	kubectl apply -k .

apply: get-secrets-from-vault run-apply clean-secrets


