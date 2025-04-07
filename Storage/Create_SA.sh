#!/bin/bash

# Variables
resourceGroupName="StorageAccountRG"
storageAccountName="sampledhaappdest"
location="centralindia"

az group create --name $resourceGroupName --location $location

# Create storage account
az storage account create \
    --name $storageAccountName \
    --resource-group $resourceGroupName \
    --location $location \
    --sku Standard_LRS \
    --kind StorageV2

echo "Storage account $storageAccountName created in $location"
