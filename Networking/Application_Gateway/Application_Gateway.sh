# Set variables
location="eastus"
resourceGroup="myResourceGroupVM"
vnetName="myVNet"
subnetName="mySubnet"
vm1Name="myVM1"
vm2Name="myVM2"
image="UbuntuLTS"
adminUsername="azureuser"

# Create a resource group
az group create --name $resourceGroup --location $location

# Create a virtual network and subnet
az network vnet create --name $vnetName --resource-group $resourceGroup --location $location --address-prefix 10.0.0.0/16 --subnet-name $subnetName --subnet-prefix 10.0.0.0/24

# Create public IP addresses for each VM
az network public-ip create --name ${vm1Name}PublicIP --resource-group $resourceGroup --allocation-method Dynamic
az network public-ip create --name ${vm2Name}PublicIP --resource-group $resourceGroup --allocation-method Dynamic

# Create network interfaces for each VM
az network nic create --name ${vm1Name}NIC --resource-group $resourceGroup --vnet-name $vnetName --subnet $subnetName --public-ip-address ${vm1Name}PublicIP
az network nic create --name ${vm2Name}NIC --resource-group $resourceGroup --vnet-name $vnetName --subnet $subnetName --public-ip-address ${vm2Name}PublicIP

# Create two VMs
az vm create --name $vm1Name --resource-group $resourceGroup --nics ${vm1Name}NIC --image $image --admin-username $adminUsername --generate-ssh-keys --custom-data cloud-init-images.txt
az vm create --name $vm2Name --resource-group $resourceGroup --nics ${vm2Name}NIC --image $image --admin-username $adminUsername --generate-ssh-keys --custom-data cloud-init-videos.txt
