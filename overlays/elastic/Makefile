

ELASTIC_VERSION := v8.5.1

helm:
	helm repo add elastic https://helm.elastic.co
	helm repo update elastic


elasticSearch-deployment:
	helm template elasticsearch elastic/elasticsearch --version=${ELASTIC_VERSION} --values=elasticsearch/values-elasticsearch.yaml > elasticsearch/helm-elasticsearch.yaml

elasticsearch: helm elasticSearch-deployment

run-dump: 
	kubectl kustomize .

dump:  elasticsearch run-dump

run-apply:  
	kubectl apply -k .

apply:  elasticsearch run-apply

run-destroy:
	kubectl delete -k .

destroy:  elasticsearch run-destroy