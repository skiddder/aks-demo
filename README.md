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
| `dockerfiles`     | Dockerfiles for source code                |
| `src`             | Sample source code for POI, Trips, User (Java), UserProfile (Node.JS), and TripViewer                     |
| `.gitignore`      | Define what to ignore at commit time.      |
| `CODE_OF_CONDUCT.md` | Code of conduct.                        |
| `LICENSE`         | The license for the sample.                |

We start with creating the AKS cluster in Azure. You will need a tenant where you have admin consent privileges as well as an Azure subscription with owner permissions.

There are two scripts to setup the AKS cluster:
az-app-create.sh -> creates the required app registrations in your tenant
az-aks-create.sh -> creates the AKS cluster itself

The logic is separated into two scripts in case you have your AKS subscription associated to another tenant as you have admin consent privileges in (most of the time as a developer this will be the case in an enterprise environment). This allows you to run the app and service principal creation against your test tenant and then in a 2nd step create the AKS cluster in another tenant's context (i.e. the development subuscription of your employer).

## Contributing

This is mainly a privateley used repo. Feel free to clone and use it at own risk. 
