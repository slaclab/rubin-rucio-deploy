helm:
	helm repo add rucio https://rucio.github.io/helm-charts
	helm repo update

rucio-server: helm
	helm template usdf rucio/rucio-server --values=values-rucio-server.yaml --values=etc/.secrets/db-conn.yaml > helm-rucio-server.yaml

rucio-daemons: helm
	helm template usdf rucio/rucio-daemons --values=values-rucio-daemons.yaml --values=etc/.secrets/db-conn.yaml > helm-rucio-daemons.yaml

rucio-ui: helm
	helm template usdf rucio/rucio-ui --values=values-rucio-ui.yaml --values=etc/.secrets/db-conn.yaml > helm-rucio-ui.yaml

rucio: rucio-server rucio-daemons rucio-ui

package-reaper-certs:
	rm -rf etc/.secrets/grid-certificates
	mkdir -p etc/.secrets/grid-certificates
	cp /etc/grid-security/certificates/*.0 etc/.secrets/grid-certificates/
	cp /etc/grid-security/certificates/*.signing_policy etc/.secrets/grid-certificates/
	cd etc/.secrets && tar cfz grid-certificates.tar.gz grid-certificates/

store-reaper-certs: package-reaper-certs
	base64 --wrap=0 etc/.secrets/grid-certificates.tar.gz | vault kv patch secret/rubin/usdf-rucio-dev/rucio grid-certificates.tar.gz=-

get-secrets:
	mkdir -p etc/.secrets
	vault kv get --field=usdf-db-conn secret/rubin/usdf-rucio-dev/rucio  > etc/.secrets/db-conn.yaml
	vault kv get --field=usdf-server-hostkey secret/rubin/usdf-rucio-dev/rucio  > etc/.secrets/hostkey.pem
	vault kv get --field=usdf-server-hostcert secret/rubin/usdf-rucio-dev/rucio  > etc/.secrets/hostcert.pem
	vault kv get --field=usdf-server-cafile secret/rubin/usdf-rucio-dev/rucio  > etc/.secrets/ca.pem
	vault kv get --field=username secret/rubin/usdf-rucio-dev/database  > etc/.secrets/username
	vault kv get --field=password secret/rubin/usdf-rucio-dev/database  > etc/.secrets/password

	#vault kv get --field=grid-certificates.tar.gz secret/rubin/usdf-rucio-dev/rucio | base64 --decode --ignore-garbage > etc/.secrets/grid-certificates.tar.gz && cd etc/.secrets/ && tar xfvz grid-certificates.tar.gz && rm grid-certificates.tar.gz

clean-secrets:
	rm -rf etc/.secrets

run-dump: 
	kubectl kustomize .

dump: get-secrets rucio run-dump clean-secrets

run-apply:  
	kubectl apply -k .

apply: get-secrets rucio run-apply clean-secrets


