#!/bin/bash

# Variables
resourceGroupName="MyResourceGroup"
location="eastus"
vnetName="MyVNet"
subnet1Name="MySubnet1"
subnet2Name="MySubnet2"
vm1Name="myvm1"
vm2Name="myvm2"
vmSize="Standard_B1s"
image="Ubuntu2204"

# Create resource group
az group create --name $resourceGroupName --location $location

# Create virtual network with two subnets
az network vnet create --name $vnetName --resource-group $resourceGroupName --location $location --address-prefix 10.0.0.0/16
az network vnet subnet create --vnet-name $vnetName --resource-group $resourceGroupName --name $subnet1Name --address-prefix 10.0.1.0/24
az network vnet subnet create --vnet-name $vnetName --resource-group $resourceGroupName --name $subnet2Name --address-prefix 10.0.2.0/24

# Create two VMs
az vm create --resource-group $resourceGroupName --name $vm1Name --location $location --vnet-name $vnetName --subnet $subnet1Name --image $image --size $vmSize --public-ip-address-dns-name $vm1Name-dns --admin-username azureuser --generate-ssh-keys
az vm create --resource-group $resourceGroupName --name $vm2Name --location $location --vnet-name $vnetName --subnet $subnet2Name --image $image --size $vmSize --public-ip-address-dns-name $vm2Name-dns --admin-username azureuser --generate-ssh-keys

echo "Two VMs and a VNet with two subnets have been created in Azure"
