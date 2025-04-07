#!/bin/bash

# Variables
westResourceGroup="WestUSResourceGroup"
westVNet="WestUSVNet"
westGatewayIp="WestUSGatewayIp"
westGateway="WestUSGateway"
eastResourceGroup="EastUSResourceGroup"
eastVNet="EastUSVNet"
eastGatewayIp="EastUSGatewayIp"
eastGateway="EastUSGateway"
sharedKey="YourSharedKey"

# Create West US resources
az group create --name $westResourceGroup --location westus
az network vnet create --resource-group $westResourceGroup --name $westVNet --address-prefixes 10.3.0.0/16 --subnet-name GatewaySubnet --subnet-prefixes 10.3.1.0/24
az network public-ip create --resource-group $westResourceGroup --name $westGatewayIp --sku Standard
az network vnet-gateway create --resource-group $westResourceGroup --name $westGateway --vnet $westVNet --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --public-ip-address $westGatewayIp

# Create East US resources
az group create --name $eastResourceGroup --location eastus
az network vnet create --resource-group $eastResourceGroup --name $eastVNet --address-prefixes 10.2.0.0/16 --subnet-name GatewaySubnet --subnet-prefixes 10.2.1.0/24
az network public-ip create --resource-group $eastResourceGroup --name $eastGatewayIp --sku Standard
az network vnet-gateway create --resource-group $eastResourceGroup --name $eastGateway --vnet $eastVNet --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --public-ip-address $eastGatewayIp

# Create local gateways and VPN connections
az network local-gateway create --resource-group $westResourceGroup --name EastUSLocalGateway --gateway-ip-address 13.90.57.75 --local-address-prefixes 10.2.0.0/16
az network local-gateway create --resource-group $eastResourceGroup --name WestUSLocalGateway --gateway-ip-address 157.56.166.109 --local-address-prefixes 10.3.0.0/16
az network vpn-connection create --resource-group $westResourceGroup --name WestToEastConnection --vnet-gateway1 $westGateway --local-gateway2 EastUSLocalGateway --shared-key $sharedKey
az network vpn-connection create --resource-group $eastResourceGroup --name EastToWestConnection --vnet-gateway1 $eastGateway --local-gateway2 WestUSLocalGateway --shared-key $sharedKey