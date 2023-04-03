#!/bin/sh
# Create a storage account for the out-of-band saving Terraform state

echo "Enter the region for the storage account: "
read region
echo "Enter the name for the storage account resource group: "
read rg_name
echo "Enter the name for the resource group owner: "
read owner

echo "Creating resource group $rg_name in $region"
# Create the resource group
az group create \
    --name $rg_name \
    --location $region \
    --tags "Owner=$owner"

echo "Enter the name for the storage account: "
read storage_account_name

echo "Creating storage account $storage_account_name in $region"
# Create the storage account
az storage account create \
    --name $storage_account_name \
    --resource-group $rg_name \
    --location $region \
    --sku Standard_LRS

#Create the storage container
echo "Enter the name for the storage container: "
read storage_container_name

echo "Creating storage container $storage_container_name in $storage_account_name"
az storage container create \
    --name $storage_container_name \
    --account-name $storage_account_name \
    -g $rg_name

echo "WARNING: This script will overwrite the backend.conf file in the templates directory"
echo "Enter 'yes' to continue: "
read prompt

if [ $prompt != "yes" ]
then
    echo "Exiting without updating the backend.conf file"
    exit 1
fi

# Save the storage account name and container name to the backend.conf file
echo "Updating the ../templates/backend.conf file"
echo "resource_group_name = $rg_name" > ../templates/backend.conf
echo "storage_account_name = $storage_account_name" >> ../templates/backend.conf
echo "container_name = $storage_container_name" >> ../templates/backend.conf
echo "key = terraform.tfstate" >> ../templates/backend.conf

echo "Done