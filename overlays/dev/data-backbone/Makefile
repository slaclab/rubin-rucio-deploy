SECRET_PATH ?= secret/rubin/usdf-rucio-data-backbone
ENV = $(notdir ${CURDIR})

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	# internal redis password and Ceph notification secret
	set -e; for i in redis; do vault kv get --field=$$i ${SECRET_PATH}/${ENV} > etc/.secrets/$$i ; done

clean-secrets:
	rm -rf etc/.secrets/
	rmdir ./etc

run-dump:
	kubectl kustomize .

dump: get-secrets-from-vault run-dump clean-secrets

run-apply:
	kubectl create clusterrolebinding strimzi-cluster-operator-namespaced --clusterrole=strimzi-cluster-operator-namespaced --serviceaccount strimzi:strimzi-cluster-operator
	kubectl create clusterrolebinding strimzi-cluster-operator-watched --clusterrole=strimzi-cluster-operator-watched --serviceaccount strimzi:strimzi-cluster-operator
	kubectl create clusterrolebinding strimzi-cluster-operator-entity-operator-delegation --clusterrole=strimzi-entity-operator --serviceaccount strimzi:strimzi-cluster-operator
	kubectl apply -f strimzi-0.35.1.yaml -n strimzi
	kubectl apply -f kafka-persistent.yaml -n usdf-kafka
	kubectl apply -k .

apply: get-secrets-from-vault run-apply clean-secrets


