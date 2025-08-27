# Deploy Online Boutique on Azure Kubernetes Service (AKS) using Terraform

This is still work in progress. Use at your own risk.

This page walks you through the steps required to deploy the [Online Boutique](https://github.com/PitiRR/microservices-demo) sample application on a [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/) cluster using Terraform. 

Note: this project takes heavy inspiration from GCP microservices-demo, but the infrastructure, deployment and CI/CD has been changed for a practical project and a learning exercise of best practices.

## Prerequisites

1. Azure Account: [Create or reuse a resource group](https://portal.azure.com/) on Azure. You may [create a free account](https://azure-int.microsoft.com/en-us/free/).
1. Azure CLI: [Installation guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
1. Terraform: [Installation guide](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

After installing the tools, log-in to Azure from your terminal:

```bash
az login
az account set --subscription "SUBSCRIPTION_ID"
```

## Setup: Create Secure Backend

You need to create a storage account before Terraform can use it as Backend. Read more here: [Terraform and the chicken and egg problem](https://netmemo.github.io/post/tf-chicken-egg/).

You need to perform a one-time setup of a storage account to keep Statefile in a secure location. For this, we will use Azure CLI.

1. Choose a name for your resource group, storage account and container name - **they must be unique**. In the code block below you are provided with examples.
1. Run the following commands to create a storage account that will be used for Statefile:

```bash
export RESOURCE_GROUP_NAME="rg-tfstate"
export STORAGE_ACCOUNT_NAME="tfstatemicroservicesdemo"
export CONTAINER_NAME="tfstate"

# Create Resource Group
az group create --name $RESOURCE_GROUP_NAME -l "West Europe"

# Create Storage Account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --sku Standard_LRS

# Create Blob Container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Get the Storage accesskey and store it as an environment variable
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv) 

export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo $ARM_ACCESS_KEY
```

## Setup: Deploy the sample application

1. Clone and access the deploy Github repository.

    ```bash
    git clone https://github.com/PitiRR/microservices-demo-deploy.git
    cd microservices-demo-deploy/terraform
    ```

1. Configure the backend: Head to `backend.tf` and replace the parameters with your values. For example, using:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<RESOURCE_GROUP_NAME>"
    storage_account_name = "<STORAGE_ACCOUNT_NAME>"
    container_name       = "<CONTAINER_NAME>"
    key                  = "terraform.tfstate"
  }
}
```

1. Initialize Terraform:

    ```bash
    terraform init
    ```

(If prompted, type `yes` to copy existing state to the new backend)

1. Always verify the resources that will be created:

    ```bash
    terraform plan
    ```

1. If you are satisfied with proposed changes, you may apply the configuration - it may take up to 15 minutes:

    ```bash
    terraform apply
    ```

## Setup: Update Github Secrets to push future changes to ACR

To ensure future changes done to `microservices-demo` are applied to reality, we must build the Dockerfile and push it somewhere accessible to the Kubernetes Cluster. This place is `Azure Container Registry (ACR)`. Follow instructions below to configure Github Actions to push the changes.

## Accessing the Application

Once the Terraform script has finished, you can locate the frontend's external IP address to access the sample application.

1. Connect `kubectl` to your new AKS cluster:

```bash
az aks get-credentials --resource-group rg-boutique-shop-prod --name aks-rg-boutique-shop-prod
```

2. Get the application's public IP address

```bash
kubectl get service frontend-external -n default
```

Look for the value in the `EXTERNAL-IP` column. Paste this IP address into your browser to see the Online Boutique shop.

## Clean up

To avoid incurring charges to your account for the resources used in this sample application, you can destroy the infrastructure at any point.

To remove the individual resources created for by Terraform without deleting the project:

1. Run the following command to destroy all resources:

  ```bash
  terraform destroy
  ```

**Note**: remote backend is separated from Terraform resources by design. To delete the tfstate resource group:

```bash
az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait
```