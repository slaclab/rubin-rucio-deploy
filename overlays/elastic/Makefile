

ELASTIC_VERSION := 0.8.0

helm:
	helm repo add elastic https://helm.elastic.co
	helm repo update elastic


elasticsearch-deployment:
	helm template elasticsearch elastic/eck-elasticsearch --version=${ELASTIC_VERSION} --values=elasticsearch/values-elasticsearch.yaml > elasticsearch/helm-elasticsearch.yaml

elasticsearch: helm elasticsearch-deployment

run-dump: 
	kubectl kustomize .

dump:  elasticsearch run-dump

run-apply:  
	kubectl apply -k .

apply:  elasticsearch run-apply

run-destroy:
	kubectl delete -k .

destroy:  elasticsearch run-destroy