#!/bin/bash

# Variables
resourceGroupName="CustomTableResourceGroup"
location="eastus"
vnetName="CTVnet"
vnetAddressPrefix="10.0.0.0/16"
websubnetName="WebSubnet"
scansubnetName="ScanSubnet"
logicsubnetName="LogicSubnet"
websubnetPrefix="10.0.1.0/24"
scansubnetPrefix="10.0.2.0/24"
logicsubnetPrefix="10.0.3.0/24"
adminUsername="azureuser"
adminPassword="HarishAppana@123"

# Create Resource Group
az group create --name $resourceGroupName --location $location

# Create Virtual Network
az network vnet create --name $vnetName --resource-group $resourceGroupName --location $location --address-prefix $vnetAddressPrefix

# Create Subnets
az network vnet subnet create --address-prefix $websubnetPrefix --name $websubnetName --resource-group $resourceGroupName --vnet-name $vnetName
az network vnet subnet create --address-prefix $scansubnetPrefix --name $scansubnetName --resource-group $resourceGroupName --vnet-name $vnetName
az network vnet subnet create --address-prefix $logicsubnetPrefix --name $logicsubnetName --resource-group $resourceGroupName --vnet-name $vnetName

# Create VMs in each Subnet
az vm create --resource-group $resourceGroupName --name "WebVM" --location $location --vnet-name $vnetName --subnet $websubnetName --image Win2019Datacenter --admin-username $adminUsername --admin-password $adminPassword
az vm create --resource-group $resourceGroupName --name "ScanVM" --location $location --vnet-name $vnetName --subnet $scansubnetName --image Win2019Datacenter --admin-username $adminUsername --admin-password $adminPassword
az vm create --resource-group $resourceGroupName --name "LogicVM" --location $location --vnet-name $vnetName --subnet $logicsubnetName --image Win2019Datacenter --admin-username $adminUsername --admin-password $adminPassword

# WebVM  --> ScanVM --> LogicVM

# Users ---> ScanVM  --> WebVM