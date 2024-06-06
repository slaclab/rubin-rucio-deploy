OPEN_VERSION := 2.14.0

helm:
	helm repo add elastic https://helm.elastic.co
	helm repo update opensearch


open-deployment:
	helm template opensearch opensearch/opensearch-dashboards --version=${OPEN_VERSION} --values=values-opensearch-master.yaml > helm-opensearch-dashboards.yaml


opensearch: helm open-deployment

run-dump: 
	kubectl kustomize .

dump:  opensearch run-dump

run-apply:  
	kubectl apply -k .

apply:  opensearch run-apply

run-destroy:
	kubectl delete -k .

destroy:  opensearch run-destroy