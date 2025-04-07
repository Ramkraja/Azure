#!/bin/bash

# Variables
resourceGroupName="StorageAccountRG"
storageAccountName="sampledhaappsrc"
containerName="samplecontainersrc"
filePath="samplefile.json"  
blobName="samplefile.json" 

# Get storage account key
accountKey=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' -o tsv)

# Create a container
az storage container create \
    --name $containerName \
    --account-name $storageAccountName \
    --account-key $accountKey

echo "Container $containerName created in $storageAccountName"

# Upload the file to the container
az storage blob upload \
    --container-name $containerName \
    --file $filePath \
    --name $blobName \
    --account-name $storageAccountName \
    --account-key $accountKey

echo "File $blobName uploaded to $containerName in $storageAccountName"
