# Variables for VNet1 and VNet2 in East US
location1="eastus"
vnetName1="VNet1"
vnetName2="VNet2"
resourceGroup="VnetPeeringRG"
addressPrefix1="10.0.0.0/16"
addressPrefix2="10.1.0.0/16"

# Variables for VNet3 in West US
location2="westus"
vnetName3="VNet3"
addressPrefix3="10.2.0.0/16"

az group create --name $resourceGroup --location $location1

# Create VNet1 in East US
az network vnet create \
    --name $vnetName1 \
    --resource-group $resourceGroup \
    --location $location1 \
    --address-prefix $addressPrefix1

# Create VNet2 in East US
az network vnet create \
    --name $vnetName2 \
    --resource-group $resourceGroup \
    --location $location1 \
    --address-prefix $addressPrefix2

# Create VNet3 in West US
az network vnet create \
    --name $vnetName3 \
    --resource-group $resourceGroup \
    --location $location2 \
    --address-prefix $addressPrefix3

