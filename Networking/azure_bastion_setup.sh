#!/bin/bash

# Variables
resourceGroup='BastionResourceGroup'
location='eastus'
vnetName='MyVNet'
bastionName='MyBastion'
vmName='MyWindowsVM'
vmSize='Standard_B1s'  
adminUsername='azureuser'

# Create Resource Group
az group create --name $resourceGroup --location $location

# Create Virtual Network and Subnets
az network vnet create --resource-group $resourceGroup --name $vnetName --address-prefix 10.0.0.0/16 --subnet-name AzureBastionSubnet --subnet-prefix 10.0.0.0/24
az network vnet subnet create --resource-group $resourceGroup --vnet-name $vnetName --name MySubnet --address-prefixes 10.0.1.0/24

# Create Public IP Address for Bastion
az network public-ip create --resource-group $resourceGroup --name MyBastionPublicIP --sku Standard --location $location

# Create Azure Bastion
az network bastion create --name $bastionName --public-ip-address MyBastionPublicIP --resource-group $resourceGroup --vnet-name $vnetName --location $location

az vm create \
    --resource-group BastionResourceGroup \
    --name vmlinux \
    --image Ubuntu2204 \
    --admin-username azureuser \
    --admin-password "AppDefinition@123" \
    --size Standard_B1s \
    --vnet-name MyVNet \
    --subnet MySubnet \
    --public-ip-address ""

 