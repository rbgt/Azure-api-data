terraform {
  backend "azurerm" {
    resource_group_name  = "rg-shared"
    storage_account_name = "tfstateblobproject"
    container_name       = "tfstatecontainer"
    key                  = "projectstate.tfstate"
    # Touchy part to authenticate with Azure and deploy the resources
    use_azuread_auth = true
    use_oidc = true
  }
}