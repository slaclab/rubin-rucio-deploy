TAG ?= latest

update-grid-security-files:
	cp /etc/grid-security/certificates/*.0 grid-certificates/
	cp /etc/grid-security/certificates/*.signing_policy grid-certificates/

grid-security-files-docker: update-grid-security-files
	docker build -f Dockerfile.grid-certificates -t slaclab/grid-security-files:$(TAG) .
	docker push slaclab/grid-security-files:$(TAG)

helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update

# Dev Deployment Config Generation
rucio-server-dev: helm
	helm template usdf rucio/rucio-server --values=overlays/dev/values-rucio-server.yaml --values=secret/db-conn.yaml > overlays/dev/helm-rucio-server.yaml

rucio-daemons-dev: helm
	helm template usdf rucio/rucio-daemons --values=overlays/dev/values-rucio-daemons.yaml --values=secret/db-conn.yaml > overlays/dev/helm-rucio-daemons.yaml

rucio-ui-dev: helm
	helm template usdf rucio/rucio-ui --values=overlays/dev/values-rucio-ui.yaml --values=secret/db-conn.yaml > overlays/dev/helm-rucio-ui.yaml

# Prod Deployment Config Generation
rucio-server-prod: helm
	helm template usdf rucio/rucio-server --values=overlays/prod/values-rucio-server.yaml --values=secret/db-conn.yaml > overlays/prod/helm-rucio-server.yaml

rucio-daemons-prod: helm
	helm template usdf rucio/rucio-daemons --values=overlays/prod/values-rucio-daemons.yaml --values=secret/db-conn.yaml > overlays/prod/helm-rucio-daemons.yaml

rucio-ui-prod: helm
	helm template usdf rucio/rucio-ui --values=overlays/prod/values-rucio-ui.yaml --values=secret/db-conn.yaml > overlays/prod/helm-rucio-ui.yaml

rucio-dev: rucio-server-dev rucio-daemons-dev rucio-ui-dev
rucio-prod: rucio-server-prod rucio-daemons-prod rucio-ui-prod

run-apply-dev:
	kubectl apply -k overlays/dev

run-apply-prod:
	kubectl apply -k overlays/prod
