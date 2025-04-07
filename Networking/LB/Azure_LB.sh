# Create a resource group named VMMSRGTest in the East US region.
az group create --name VMMSRGTest --location eastus

# Create a virtual network named VNet1 in the VMMSRGTest resource group with a subnet named Subnet1.
az network vnet create --name VNet1 --resource-group VMMSRGTest --location eastus --address-prefix 10.0.0.0/16 --subnet-name Subnet1 --subnet-prefix 10.0.1.0/24

# Create a static public IP address named LBPubIP in the VMMSRGTest resource group.
az network public-ip create --name LBPubIP --resource-group VMMSRGTest --location eastus --allocation-method Static --sku Standard

# Create a load balancer named MyLoadBalancer that uses the public IP address created earlier.
az network lb create --name MyLoadBalancer --resource-group VMMSRGTest --public-ip-address LBPubIP --frontend-ip-name MyFrontEnd --backend-pool-name MyBackEndPool

# Create a health probe for the load balancer to monitor the health of the backend services.
az network lb probe create --resource-group VMMSRGTest --lb-name MyLoadBalancer --name MyHealthProbe --protocol tcp --port 80 --interval 15 --threshold 2

# Create a load balancing rule to distribute incoming TCP traffic on port 80 to the backend pool using the health probe.
az network lb rule create --resource-group VMMSRGTest --lb-name MyLoadBalancer --name MyHTTPRule --protocol Tcp --frontend-port 80 --backend-port 80 --frontend-ip-name MyFrontEnd --backend-pool-name MyBackEndPool --probe-name MyHealthProbe

# Create a network security group (NSG) named MyNSG in the VMMSRGTest resource group.
az network nsg create --name MyNSG --resource-group VMMSRGTest --location eastus

# Create an NSG rule to allow incoming TCP traffic on port 80.
az network nsg rule create --nsg-name MyNSG --resource-group VMMSRGTest --name MyHTTPRule --protocol Tcp --direction Inbound --priority 1000 --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 --access Allow

# Create a virtual machine scale set (VMSS) named MyVMSS, using the specified network, subnet, load balancer, and NSG settings.
# It also initializes VM instances with the Ubuntu 22.04 image and sets up SSH keys for the admin user.
az vmss create --name MyVMSS --resource-group VMMSRGTest --location eastus --vnet-name VNet1 --subnet Subnet1 --image Ubuntu2204 --upgrade-policy-mode Automatic --admin-username azureuser --generate-ssh-keys --load-balancer MyLoadBalancer --backend-pool-name MyBackEndPool --nsg MyNSG --custom-data cloud-init.txt
