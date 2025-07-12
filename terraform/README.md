# Use Terraform to deploy Online Boutique on an ~~GKE cluster~~ AKS Cluster

This is still work in progress. Use at your own risk.

This page walks you through the steps required to deploy the [Online Boutique](https://github.com/PitiRR/microservices-demo) sample application on a [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/) cluster using Terraform. 

Note: this project takes heavy inspiration from GCP microservices-demo, but the infrastructure, deployment and CI/CD has been changed for a practical, learning exercise.

## Prerequisites

1. [Create or reuse a resource group](https://portal.azure.com/) on Azure. You may [create a free account](https://azure-int.microsoft.com/en-us/free/).

## Deploy the sample application

1. Clone the deploy Github repository.

    ```bash
    git clone https://github.com/PitiRR/microservices-demo-deploy.git
    ```

2. Move into the `terraform/` directory which contains the Terraform installation scripts.

    ```bash
    cd microservices-demo-deploy/terraform
    ```

3. Create a `terraform.tfvars` file and add `<subscription_id>` variable with the [Subscription ID](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id).

```bash
vim terraform.tfvars
```

```tf
subscription_id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

4. Initialize Terraform.

    ```bash
    terraform init
    ```

5. See what resources will be created.

    ```bash
    terraform plan
    ```

6. Create the resources and deploy the sample.

    ```bash
    terraform apply
    ```

    1. If there is a confirmation prompt, type `yes` and hit Enter/Return.

    Note: This step can take about 10 minutes. Do not interrupt the process.

Once the Terraform script has finished, you can locate the frontend's external IP address to access the sample application.

- Option 1:

    ```bash
    kubectl get service frontend-external | awk '{print $4}'
    ```

- Option 2: On Google Cloud Console, navigate to "Kubernetes Engine" and then "Services & Ingress" to locate the Endpoint associated with "frontend-external".

## Clean up

To avoid incurring charges to your account for the resources used in this sample application, either delete the project that contains the resources, or keep the project and delete the individual resources.

To remove the individual resources created for by Terraform without deleting the project:

1. Navigate to the `terraform/` directory.

2. Set `deletion_protection` to `false` for the `google_container_cluster` resource (GKE cluster).

   ```bash
   # Uncomment the line: "deletion_protection = false"
   sed -i "s/# deletion_protection/deletion_protection/g" main.tf

   # Re-apply the Terraform to update the state
   terraform apply
   ```

3. Run the following command:

   ```bash
   terraform destroy
   ```

   1. If there is a confirmation prompt, type `yes` and hit Enter/Return.
