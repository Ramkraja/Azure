#!/bin/bash

# Variables
LOCATION="eastus"
RESOURCE_GROUP="MyResourceGroup"
VNET_NAME="MyVNet"
SUBNET1_NAME="MySubnet1"
SUBNET2_NAME="MySubnet2"
VM_NAME1="MyWindowsVM1"
VM_NAME2="MyWindowsVM2"
VM_SIZE="Standard_B2s"
NSG_NAME1="MyNSG1"
NSG_NAME2="MyNSG2"
USERNAME="azureuser"
PASSWORD="YourSecurePassword123!"

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a virtual network with two subnets
az network vnet create --resource-group $RESOURCE_GROUP --location $LOCATION --name $VNET_NAME --address-prefix "10.0.0.0/16"
az network vnet subnet create --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $SUBNET1_NAME --address-prefix "10.0.1.0/24"
az network vnet subnet create --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $SUBNET2_NAME --address-prefix "10.0.2.0/24"

# Create two Network Security Groups and allow RDP access within the VNet
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME1 --location $LOCATION
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME2 --location $LOCATION
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $NSG_NAME1 --name "AllowRDP" --protocol Tcp --priority 1000 --destination-port-range 3389 --access Allow --direction Inbound --source-address-prefix "VirtualNetwork"
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $NSG_NAME2 --name "AllowRDP" --protocol Tcp --priority 1000 --destination-port-range 3389 --access Allow --direction Inbound --source-address-prefix "VirtualNetwork"

# Create two network interfaces and attach them to the subnets and NSGs
az network nic create --resource-group $RESOURCE_GROUP --name $VM_NAME1"NIC" --vnet-name $VNET_NAME --subnet $SUBNET1_NAME --network-security-group $NSG_NAME1
az network nic create --resource-group $RESOURCE_GROUP --name $VM_NAME2"NIC" --vnet-name $VNET_NAME --subnet $SUBNET2_NAME --network-security-group $NSG_NAME2

# Create two VMs, one in each subnet
az vm create --resource-group $RESOURCE_GROUP --name $VM_NAME1 --nics $VM_NAME1"NIC" --image Win2019Datacenter --size $VM_SIZE --admin-username $USERNAME --admin-password $PASSWORD --no-wait
az vm create --resource-group $RESOURCE_GROUP --name $VM_NAME2 --nics $VM_NAME2"NIC" --image Win2019Datacenter --size $VM_SIZE --admin-username $USERNAME --admin-password $PASSWORD --no-wait
