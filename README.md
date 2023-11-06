# rubin-rucio-deploy
## Deployment framework for Rubin USDF Rucio. 

This project requires a Kubernetes cluster with permissions to run operators as needed. Once you have access to your Kubernetes cluster, you can deploy Rucio for a given overlay (found in overlays/[dev,prod]) using the Makefile found there with (most simply)

    make apply

This will run multiple steps, downloading Secrets from Vault and ending up using Kustomize to create or update `rucio`, `rucio-db`, `kafka`, and other namespaces, as well as the resources (servers/daemons) to run a Rucio application in those namespaces. Rucio application containers will run in the `rucio` namespace, while the `rucio-db` namespace is used for a CloudNativePG operator managed PostgreSQL database. The `kafka` namespace contains a Strimzi-deployed Kafka cluster definition to serve as the transfer messaging portion of the Rubin Data Backbone.

This framework uses `kustomize` to allow modification of Helm template outputs from the official Rucio Helm chart. Secrets stored in Vault are downloaded by the controlling Makefile for a given overlay. Secrets are then created in the cluster and provided to the Rucio application through a combination of Kustomize creating the `Secret` objects, and the Rucio Helm chart values determining which containers/daemons those secrets are mounted to.

Before deploying Rucio, the secrets and credentials needed for the application will need to be pushed to Vault. Vault-resident secrets will be downloaded when `make apply` in the controlling Makefile for a given overlay is run.
 
If you update the values-*.yaml files, be sure to also update the rucio helm templates with the following
Makefile command for your chosen overlay:

    make rucio  # update from upstream helm charts
