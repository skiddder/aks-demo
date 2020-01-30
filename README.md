# AKS Demo with RBAC-AAD Integration for enterprise use cases

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

The application used for this demo is a heavily modified and recreated version of the original [My Driving application](https://github.com/Azure-Samples/MyDriving).

## Contents

| File/folder       | Description                                |
|-------------------|--------------------------------------------|
| `compose`         | Service definitions                        |
| `dockerfiles`     | Dockerfiles for source code                |
| `grafana`         | Monitoring configuration                   |
| `src`             | Sample source code for POI, Trips, User (Java), UserProfile (Node.JS), and TripViewer                     |
| `YAML`            | Kubernetes configuration files             |
| `.gitignore`      | Define what to ignore at commit time.      |
| `CODE_OF_CONDUCT.md` | Code of conduct.                        |
| `LICENSE`         | The license for the sample.                |
| az-app-create.sh  | creates the required app registrations in your tenant |
| az-aks-create.sh  | creates the AKS cluster itself             |

Please start with creating the AKS cluster in Azure. You will need a tenant where you have admin consent privileges as well as an Azure subscription with owner permissions.

## Getting started

### Deploy the AKS cluster

The logic is separated into two scripts in case you have your AKS subscription associated to another tenant than you have admin consent privileges in (most of the time as a developer this will be the case in an enterprise environment). This allows you to run the app and service principal creation against your test tenant and then in a 2nd step create the AKS cluster in another tenant's context (i.e. the development subscription of your employer).

### Build the containers from dockerfiles

As prerequisite you will need a local docker version installed. 
In Azure create an Azure SQL DB called 'mydrivingDB'.
Use the data-load container-image to create the schema and populate the database with data by running it in your AKS cluster (or local docker host):

```kubectl run dataload --image=<insert-your-container-registry-name-here>/mydriving/data-load:v1 --env="SQLFQDN={your-sql-db-name}:1433" --env="SQLUSER={your-sql-admin-user}" --env="SQLPASS={yourSQLpassword}" --env="SQLDB=mydrivingDB"```

In Azure create a Key Vault. Use the shell script ```keyvault-secrets.sh``` to populate the keyvault with the connection details:

Run the following commands form your local cmd/bash to build and push the container images:

```docker build --no-cache -t <insert-your-container-registry-name-here>/user-java:1.0 -f dockerfiles/Dockerfile_0 ./src/user-java```

```docker push <insert-your-container-registry-name-here>/tripinsights/user-java:1.0```

```docker build --no-cache -t <insert-your-container-registry-name-here>/tripinsights/tripviewer:1.0 -f dockerfiles/Dockerfile_1 ./src/tripviewer```

```docker push <insert-your-container-registry-name-here>/tripinsights/tripviewer:1.0```

```docker build --no-cache -t <insert-your-container-registry-name-here>/tripinsights/userprofile:1.0 -f dockerfiles/Dockerfile_2 ./src/userprofile```

```docker push <insert-your-container-registry-name-here>/tripinsights/userprofile:1.0```

```docker build --no-cache -t <insert-your-container-registry-name-here>/tripinsights/poi:1.0 -f dockerfiles/Dockerfile_3 ./src/poi```

```docker push <insert-your-container-registry-name-here>/tripinsights/poi:1.0```

```docker build --no-cache -t <insert-your-container-registry-name-here>/tripinsights/tripapi:1.0 -f dockerfiles/Dockerfile_4 ./src/trips```

```docker push <insert-your-container-registry-name-here>/tripinsights/tripapi:1.0```

## Contributing

This is mainly a privateley used repo. Feel free to clone and use it at own risk. 
