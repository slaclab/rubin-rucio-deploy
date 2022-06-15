# rubin-rucio-deploy

Deployment scripts for Rubin USDF Rucio. Work in progress.

Once you have a access to your k8s cluster, you can deploy this with

    make apply

due to the asynchronicity of the k8s api, you may need to run make apply again while the zalando postgres operator registers itself so that the database.yaml can be applied correctly.

uses zalando postgres operator to help manage the database.

in the back, this uses `kustomize` to allow modification of helm template outputs from the official rucio helm chart. we probably want to lock to specific versions of the helm chart for produciton purposes. in order to prevent upstream changes in the helm charts from affecting our deployment, the Makefile has targets to regenerate the helm templates, which we locally version control.

if you update the values-*.yaml files, be sure to also update the rucio helm templates with:

    make rucio  # update from upstream helm charts
    make apply

still to do:
- connect rucio to the postgres database
- certs and other stuff: use vault - either with static fetches or with the operator
- general does this even work...


