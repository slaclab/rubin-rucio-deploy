helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update

# Dev Deployment Config Generation
rucio-server-dev: helm
	helm template usdf rucio/rucio-server --values=deployments/dev/values-rucio-server.yaml --values=secret/db-conn.yaml > deployments/dev/helm-rucio-server.yaml

rucio-daemons-dev: helm
	helm template usdf rucio/rucio-daemons --values=deployments/dev/values-rucio-daemons.yaml --values=secret/db-conn.yaml > deployments/dev/helm-rucio-daemons.yaml

rucio-ui-dev: helm
	helm template usdf rucio/rucio-ui --values=deployments/dev/values-rucio-ui.yaml --values=secret/db-conn.yaml > deployments/dev/helm-rucio-ui.yaml

# Prod Deployment Config Generation
rucio-server-prod: helm
	helm template usdf rucio/rucio-server --values=deployments/prod/values-rucio-server.yaml --values=secret/db-conn.yaml > deployments/prod/helm-rucio-server.yaml

rucio-daemons-prod: helm
	helm template usdf rucio/rucio-daemons --values=deployments/prod/values-rucio-daemons.yaml --values=secret/db-conn.yaml > deployments/prod/helm-rucio-daemons.yaml

rucio-ui-prod: helm
	helm template usdf rucio/rucio-ui --values=deployments/prod/values-rucio-ui.yaml --values=secret/db-conn.yaml > deployments/prod/helm-rucio-ui.yaml

rucio-dev: rucio-server-dev rucio-daemons-dev rucio-ui-dev
rucio-prod: rucio-server-prod rucio-daemons-prod rucio-ui-prod

run-apply-dev:
	kubectl apply -k deployments/dev

run-apply-prod:
	kubectl apply -k deployments/prod
