# Use the Azure CLI to create a storage account to store the Terraform state files.
This storage account will be used to store the state of each deployment step and will be accessed by Terraform to reference values stored in the various deployment state files.

Create some variables to start with

```bash
# Bash
REGION=<REGION>
STORAGEACCOUNTNAME=<UNIQUENAME>
CONTAINERNAME=<TERRAFORMSTATECONTAINER>
TFSTATE_RG=<STORAGEACCOUNTNAME?

Create a Resource Group:
```bash
az group create --name $TFSTATE_RG --location $REGION
```

Create a Storage Account:
```bash
az storage account create -n $STORAGEACCOUNTNAME -g $TFSTATE_RG -l $REGION --sku Standard_LRS
```

Create a Storage Container within the Storage Account:

```bash
az storage container-rm create --storage-account $STORAGEACCOUNTNAME --name $CONTAINERNAME -g $TFSTATE_RG
```

# Configure Variables for state management

Modify the variables within the "values.tfvars" section of the variable definitions file [values.tfvars](./values.tfvars).

Sample: 

```bash

##################################################
## 01 Remote Storage State configuration
##################################################

# Deployment state storage information
tf_state_sa_name  = "xxxx-enter-the-storage-account-name-xxxx"
tf_state_rg_name    = "xxxx-enter-the-resource-group-here-xxxx"
tf_state_container_name = "springappsterraform"
tf_state_key            = "terraform.tfstate"

```
