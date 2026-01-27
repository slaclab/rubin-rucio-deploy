SECRET_PATH ?= secret/rubin/usdf-rucio/rucio-db-prod/rucio-db/rubin
MONITOR_PATH ?= secret/rubin/usdf-rucio/rucio-db-prod/rucio-db/monitor
S3_SECRET_PATH ?= secret/rubin/usdf-rucio/rucio-db-prod/rucio-db/s3

KUBECTL_DEPLOY_CONTEXT ?= 'usdf-rucio'

ensure-context:
	if [ '$(shell kubectl config current-context)' != $(KUBECTL_DEPLOY_CONTEXT) ]; then echo "Configured deployment context inccorect; expecting $(KUBECTL_DEPLOY_CONTEXT)."; exit 1; fi

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	set -e; for i in username password; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done
	set -e; for i in client-id client-secret; do vault kv get --field=$$i $(S3_SECRET_PATH) > etc/.secrets/$$i ; done
	set -e; for i in username password url; do vault kv get --field=$$i $(MONITOR_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -rf etc/.secrets/

run-apply:
	kubectl apply -k .

run-kustomize:
	kubectl kustomize .

dump: ensure-context get-secrets-from-vault run-kustomize clean-secrets

apply: ensure-context get-secrets-from-vault run-apply clean-secrets
