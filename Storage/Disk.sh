#!/bin/bash

resourceGroupName="DiskRG"
diskName="myPremiumSSDDisk"
region="centralindia"
sizeInGB=1
skuName="Premium_LRS"
maxShares=2

az group create --name $resourceGroupName --location $region
az disk create --resource-group $resourceGroupName \
               --name $diskName \
               --size-gb $sizeInGB \
               --location $region \
               --sku $skuName \
               --max-shares $maxShares
