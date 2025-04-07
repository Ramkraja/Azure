#!/bin/bash

# Variables
resourceGroupName="SharedDiskRG"
location="centralindia"
diskName="sharedPremiumSSDDisk"
vm1Name="WindowsVM1"
vm2Name="WindowsVM2"
sizeInGB=1
skuName="Premium_LRS"
maxShares=2
adminUsername="azureuser"
adminPassword="AppDefinition@123"
vnetName="myVNet"
subnetName="mySubnet"

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a managed disk
az disk create --resource-group $resourceGroupName --name $diskName \
               --size-gb $sizeInGB --location $location \
               --sku $skuName --max-shares $maxShares

# Create VNet
az network vnet create --name $vnetName --resource-group $resourceGroupName \
                       --location $location --address-prefix "10.0.0.0/16"

# Create subnet
az network vnet subnet create --name $subnetName --resource-group $resourceGroupName \
                              --vnet-name $vnetName --address-prefix "10.0.1.0/24"

# Create public IP for first VM
az network public-ip create --name $vm1Name"PublicIP" --resource-group $resourceGroupName \
                            --location $location --allocation-method Static

# Create public IP for second VM
az network public-ip create --name $vm2Name"PublicIP" --resource-group $resourceGroupName \
                            --location $location --allocation-method Static

# Create network security group and rule for RDP
az network nsg create --resource-group $resourceGroupName --name $vm1Name"NSG" \
                      --location $location

az network nsg rule create --resource-group $resourceGroupName --nsg-name $vm1Name"NSG" \
                           --name "AllowRDP" --protocol Tcp --priority 1000 \
                           --destination-port-range 3389 --access Allow --direction Inbound

# Use the same NSG for the second VM for simplicity
az network nsg create --resource-group $resourceGroupName --name $vm2Name"NSG" \
                      --location $location

az network nsg rule create --resource-group $resourceGroupName --nsg-name $vm2Name"NSG" \
                           --name "AllowRDP" --protocol Tcp --priority 1000 \
                           --destination-port-range 3389 --access Allow --direction Inbound

# Create NIC for first VM with NSG and public IP
az network nic create --resource-group $resourceGroupName --name $vm1Name"NIC" \
                      --location $location --subnet $subnetName --vnet-name $vnetName \
                      --public-ip-address $vm1Name"PublicIP" --network-security-group $vm1Name"NSG"

# Create NIC for second VM with NSG and public IP
az network nic create --resource-group $resourceGroupName --name $vm2Name"NIC" \
                      --location $location --subnet $subnetName --vnet-name $vnetName \
                      --public-ip-address $vm2Name"PublicIP" --network-security-group $vm2Name"NSG"

# Create first Windows VM
az vm create --resource-group $resourceGroupName --name $vm1Name \
             --location $location --nics $vm1Name"NIC" \
             --image "Win2019Datacenter" --admin-username $adminUsername \
             --admin-password $adminPassword --size Standard_DS1_v2

# Create second Windows VM
az vm create --resource-group $resourceGroupName --name $vm2Name \
             --location $location --nics $vm2Name"NIC" \
             --image "Win2019Datacenter" --admin-username $adminUsername \
             --admin-password $adminPassword --size Standard_DS1_v2

# Attach the managed disk to the first VM
az vm disk attach --vm-name $vm1Name --resource-group $resourceGroupName \
                  --disk $diskName

# Attach the managed disk to the second VM
az vm disk attach --vm-name $vm2Name --resource-group $resourceGroupName \
                  --disk $diskName
