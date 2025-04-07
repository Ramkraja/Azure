#!/bin/bash

# Define variables
RESOURCE_GROUP="NATRG"
LOCATION="eastus"
VM_NAME="MyWindowsVM"
VM_SIZE="Standard_B2s"
ADMIN_USERNAME="azureuser"
ADMIN_PASSWORD="YourSecurePassword123!"  
VNET_NAME="MyVnet"
SUBNET_NAME="MySubnet"
BASTION_SUBNET_NAME="AzureBastionSubnet"
BASTION_NAME="MyBastionHost"
NSG_NAME="MyNSG"
NAT_GATEWAY_NAME="MyNATGateway"
PUBLIC_IP_FOR_NAT_NAME="MyNATPublicIP"
PUBLIC_IP_FOR_BASTION_NAME="MyBastionPublicIP"

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a virtual network and subnet
az network vnet create --resource-group $RESOURCE_GROUP --name $VNET_NAME --address-prefix 10.0.0.0/16 --subnet-name $SUBNET_NAME --subnet-prefix 10.0.1.0/24

# Create a subnet for Azure Bastion
az network vnet subnet create --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $BASTION_SUBNET_NAME --address-prefix 10.0.2.0/24

# Create a network security group
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME

# Create a public IP address for Azure Bastion
az network public-ip create --name $PUBLIC_IP_FOR_BASTION_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard --allocation-method Static

# Create Azure Bastion
az network bastion create --name $BASTION_NAME --public-ip-address $PUBLIC_IP_FOR_BASTION_NAME --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --location $LOCATION --sku Standard

# Create a public IP address for the NAT gateway
az network public-ip create --name $PUBLIC_IP_FOR_NAT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard --allocation-method Static

# Create a NAT gateway
az network nat gateway create --name $NAT_GATEWAY_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --public-ip-addresses $PUBLIC_IP_FOR_NAT_NAME

# Associate NAT gateway with the VM subnet
az network vnet subnet update --vnet-name $VNET_NAME --name $SUBNET_NAME --resource-group $RESOURCE_GROUP --nat-gateway $NAT_GATEWAY_NAME

# Create a VM without a public IP
az vm create --resource-group $RESOURCE_GROUP --name $VM_NAME --size $VM_SIZE --location $LOCATION --nsg $NSG_NAME --vnet-name $VNET_NAME --subnet $SUBNET_NAME --public-ip-address "" --image Win2019Datacenter --admin-username $ADMIN_USERNAME --admin-password $ADMIN_PASSWORD --no-wait
