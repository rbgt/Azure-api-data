# Azure IaC Template: Terraform + GitHub Actions (OIDC)

![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-azurerm_4.1-844FBA?style=flat-square&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white)

A ready-to-use template to provision **Azure** resources with **Terraform** from **GitHub Actions**, using **passwordless OIDC authentication** (workload identity federation), a **remote state** in Azure Storage and a **manual approval gate** before any change is applied.

Use it as a starting point for any project that needs Azure infrastructure deployed through CI/CD.

## Highlights

- 🔐 **No stored secrets for Azure login**: GitHub Actions gets a short-lived OIDC token, exchanged for an Entra ID token through a federated credential on the service principal.
- 🗄️ **Remote Terraform state** in an Azure Storage blob container, authenticated with Entra ID (`use_azuread_auth`, `use_oidc`).
- ✅ **Plan / Apply split**: the plan is produced in a first job and stored as an artifact; the apply job runs **only after manual approval** through a protected GitHub environment.
- 📌 **Pinned provider** (`hashicorp/azurerm = 4.1.0`) for reproducible deployments.

## Workflow

```
workflow_dispatch
      │
      ▼
┌───────────────────────────┐        ┌──────────────────────────────┐
│ Terraform-Init-Plan        │        │ Terraform-Apply              │
│ env: azure-sp-secrets      │ ─────▶ │ env: deployment-approval     │
│ az login (OIDC)            │  plan  │ (manual approval required)   │
│ terraform init + plan      │artifact│ terraform init + apply plan  │
└───────────────────────────┘        └──────────────────────────────┘
```

## Repository structure

```
.
├── .github/workflows/
│   ├── terraform-basic-workflow.yml  # Plan → approval → apply pipeline
│   └── azure-vm-deployment.yml       # Skeleton workflow for a future VM deployment
├── backend.tf    # azurerm remote state (Entra ID + OIDC auth)
├── provider.tf   # azurerm provider, pinned version
├── main.tf       # Resources to deploy (a resource group in this template)
├── variables.tf  # Location, naming prefix, subscription ID
└── output.tf     # Outputs (resource group name)
```

## Getting started

### Prerequisites

- An Azure subscription, the [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and [Terraform](https://developer.hashicorp.com/terraform/install)
- A GitHub repository created from this template

### 1. Prepare the Terraform state storage (one-off, manual)

Create a resource group `rg-shared`, a storage account `tfstateblobproject` and a blob container `tfstatecontainer`, or change these names in `backend.tf` and in the workflow.

### 2. Create the service principal

1. Register an application / service principal in Microsoft Entra ID.
2. Add a **federated identity credential** for your GitHub repository and environment.
3. Grant it the **Contributor** role on the target scope and **Storage Blob Data Contributor** on the state storage account.

### 3. Configure GitHub

- Create two environments: `azure-sp-secrets` and `deployment-approval` (add required reviewers on the latter).
- Add the secrets `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID`.

### 4. Deploy

Add your resources to `main.tf`, then run the **"Activate Terraform Script though Github Actions"** workflow from the Actions tab. Review the plan and approve the deployment.

## Contributing

Suggestions are welcome: feel free to open an issue or a pull request.
