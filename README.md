# IaC - Azure - Terraform Template

This repository contains a Terraform template for provisioning Azure resources with Github Actions.
Can be used as a starting point for new projects involving Azure, Terraform and Github Actions.

## Getting Started

These instructions will give you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on deploying the project on a live system.

### Prerequisites

Requirements for the software and other tools to build, test and push 
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Github CLI](https://cli.github.com/)

### Installing

1. At first, you need to create a new Github repository from this template.
2. Then, you need to configure the Github Actions secrets with your Azure credentials.
   - You'll need to create a Service Principal in Azure and use its Client ID and Client Secret as the Github Actions secrets AZURE_CLIENT_ID and AZURE_CLIENT_SECRET.
   - Also, you need to configure the Github Actions secrets with your Azure subscription ID as AZURE_SUBSCRIPTION_ID.
3. Then, you can run the Github Actions workflow to provision the Azure resources.

Be careful on some points : 
- A Service Principal is needed to be created manually in the Azure Active Directory of the subscription
- The Service Principal needs to have the Contributor role on the resource group rg-shared and storage blob contributor role on the storage account tfstateblobproject
- The Service Principal has to be configured with federated identity credentials for Github Actions
- The storage account tfstateblobproject needs to be created manually before running the Github Actions workflow
- The Github Actions secrets AZURE_TENANT_ID, AZURE_CLIENT_ID and AZURE_CLIENT_SECRET have to be configured with the federated identity credentials of the Service Principal
- terraform init has to be run with the backend-config parameter to use the secrets with the "use_azuread_auth = true" and "use_oidc = true" parameters in order to authenticate with Service Principal to the storage account

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For the versions
available, see the [tags on this
repository](https://github.com/PurpleBooth/a-good-readme-template/tags).

## Acknowledgments

Feel free to use this template for your own projects and comment this repository if you have any suggestions.
