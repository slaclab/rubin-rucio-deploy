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

## Add Hermes-K topic for a new DRP campaign

A common task is to add new topics that Hermes(K) will listen for a new DRP compaign. Follow the example in the
overlays/prod/rucio/values-rucio-daemons.yaml's `topic_list` to add new topics. Then do the following steps:

1. `export VAULT_ADDR=https://vault.slac.stanford.edu`
1. `vault login -method=ldap`
1. Make sure $HOME/.kube/config points to the `usdf-rucio` vCluster and `kubectl get namespace` returns correctly
1. go to the `overlays/prod` directory
1. `cd rucio/etc`
1. `git clone git@github.com:slaclab/RubinRucioPolicy.git`
1. `ln -s RubinRucioPolicy policy-package`
1. `cd -`
1. make rucio
1. make apply

this will restart most of the Rucio daemons. 

Note that the same topics also needed to be added to the `ctrl-ingestd` daemons.

## Upgrading Database Schema

1. Edit `util/upgrade-db-container.yaml`

    ```yaml
    - name: RUCIO_CFG_DATABASE_DEFAULT
      valueFrom:
        secretKeyRef:
          name: <secret name in cluster>
          key: db-connstr.txt
    ```

    To get the secret, run the following:

    ```bash
    $ kubectl get secrets | grep db-connstr
    fnal-db-connstr-<pod hash>                             Opaque                                1      16d
    ```

2. Apply `util/upgrade-db-container.yaml` to the experiment's cluster

    ```bash
    $ kubectl apply -f util/upgrade-db-container.yaml
    pod/rucio-db-upgrade created
    ```

3. Enter the pod with k9s, or

    ```bash
    $ kubectl exec -it rucio-db-upgrade -- /bin/bash
    ```

    
4. Generate the `rucio.cfg` and `alembic.ini` file and set `ALEMBIC_CONFIG` (these are the first few commands in `docker-entrypoint.sh`)

    ```bash
    $ python3 /usr/local/rucio/tools/merge_rucio_configs.py \
            -s /tmp/rucio.config.default.cfg $RUCIO_OVERRIDE_CONFIGS \
            --use-env \
            -d /opt/rucio/etc/rucio.cfg

    $ j2 /tmp/alembic.ini.j2 | sed '/^\s*$/d' > /opt/rucio/etc/alembic.ini

    $ export ALEMBIC_CONFIG=/opt/rucio/etc/alembic.ini
    ```

5. Modify `script_location` in `/opt/rucio/etc/alembic.ini` to the Rucio package's migrate repo

    ```
    script_location = /usr/local/lib/python3.9/site-packages/rucio/db/sqla/migrate_repo
    ```

6. Check the current alembic migration version
    ```bash
    alembic current
    ```

7. Follow instructions at <https://rucio.github.io/documentation/operator/database#upgrading-and-downgrading-the-database-schema>

    > Ensure that in etc/alembic.ini the database connection string is is set to the same database connection string as the etc/rucio.cfg and issue the following command to verify the changes to the upgrade of the schema:
    >
    > ```bash
    > alembic upgrade --sql $(alembic current | cut -d' ' -f1):head
    > ```
    >
    > You can edit and then apply the SQL directly on your database.
    >
    > ```bash
    > alembic upgrade head
    > ```

    Rucio developers do no advise running upgrades using alembic. Another method is to generate the sql file, then apply it with a `psql` command

    ```bash
    # In pod
    alembic upgrade --sql $(alembic current | cut -d' ' -f1):head > upgrade.sql

    # On host with psql command
    psql> source upgrade.sql
    ```

8. Delete the pod with

    ```bash
    $ kubectl delete pod/rucio-db-upgrade
    pod "rucio-db-upgrade" deleted
    ```
