

helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update
	helm template usdf rucio/rucio-server --values=values.yaml > helm.yaml

postgres-operator:
	git submodule add https://github.com/zalando/postgres-operator.git zalando-postgres-operator/deps/postgres-operator || true
	cd zalando-postgres-operator/deps/postgres-operator && git pull

run-apply: postgres-operator
	kubectl apply -k .

apply: run-apply


