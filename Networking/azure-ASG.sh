# Variables
resourceGroup="ASGResourceGroup"
location="eastus"
vnetName="AppVnet"
subnetName="AppSubnet"
nsgName="AppNetworkSecurityGroup"
image="Ubuntu2204"  
vmSize="Standard_B1s"

# ASG Variables
frontendAsgName="FrontendASG"
backendAsgName="BackendASG"

# Frontend VM Variables
frontendVmName="FrontendServer"
frontendVmNic="FrontendServerNic"
frontendVmPublicIP="FrontendServerPublicIP"
frontendVmAdminUsername="azureuser"

# Backend VM Variables
backendVmName="BackendServer"
backendVmNic="BackendServerNic"
backendVmAdminUsername="azureuser"

# Create Resource Group
az group create --name $resourceGroup --location $location

# Create Virtual Network and Subnet
az network vnet create --resource-group $resourceGroup --name $vnetName --subnet-name $subnetName

# Create Network Security Group and Rule to allow SSH
az network nsg create --resource-group $resourceGroup --name $nsgName
az network nsg rule create --resource-group $resourceGroup --nsg-name $nsgName --name AllowSSH --protocol tcp --priority 1000 --destination-port-range 22 --access allow

# Associate NSG with Subnet
az network vnet subnet update --vnet-name $vnetName --name $subnetName --resource-group $resourceGroup --network-security-group $nsgName

# Create Application Security Groups
az network asg create --resource-group $resourceGroup --name $frontendAsgName --location $location
az network asg create --resource-group $resourceGroup --name $backendAsgName --location $location

# Obtain the resource IDs of the ASGs
frontendAsgId=$(az network asg show --resource-group $resourceGroup --name $frontendAsgName --query id -o tsv)
backendAsgId=$(az network asg show --resource-group $resourceGroup --name $backendAsgName --query id -o tsv)

# Frontend Server Creation
# Create a Public IP Address for the Frontend Server
az network public-ip create --resource-group $resourceGroup --name $frontendVmPublicIP

# Create a Network Interface for the Frontend Server with Frontend ASG association
az network nic create --resource-group $resourceGroup --name $frontendVmNic --vnet-name $vnetName --subnet $subnetName --public-ip-address $frontendVmPublicIP --application-security-groups $frontendAsgId

# Create the Frontend Server with specific size and generate SSH keys
az vm create --resource-group $resourceGroup --name $frontendVmName --nics $frontendVmNic --image $image --size $vmSize --admin-username $frontendVmAdminUsername --public-ip-address-dns-name $frontendVmName-dns --generate-ssh-keys

# Backend Server Creation (without a Public IP)
# Create a Network Interface for the Backend Server with Backend ASG association
az network nic create --resource-group $resourceGroup --name $backendVmNic --vnet-name $vnetName --subnet $subnetName --application-security-groups $backendAsgId

# Create the Backend Server with specific size and generate SSH keys
az vm create --resource-group $resourceGroup --name $backendVmName --nics $backendVmNic --image $image --size $vmSize --admin-username $backendVmAdminUsername --generate-ssh-keys
