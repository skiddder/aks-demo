#!/bin/bash
# instructions:
# first create apps and service principals for RBAC. This will be achieved by executing script az-app-create.sh
# then run this script (az-aks-create.sh) to create a service principal scoped for the target subscription and create AKS

# Note: Admin Consent does not work in Cloud shell! So make sure you either run this sceript locally and login properly using az cli
# or implement a user input to wait untill you grant admin consent manually to the server app

# !! Attention !! if you do not have permission to give admin consent in the target tenant, create server-app and client-app in another tenant where you
# have admin consent permission. In this case you need to execute the script az-app-create.sh in the context of the other tenant
# all users you want to grant RBAC permissions/roles to must origin from that other tenant then. Guest users will work. In the rbac-binding.yaml file
# you need to use the user's objectId in that other tenant in this case. 

# the sh scripts are derived from the following docs page: https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli

# ----> execute this script within the context of the subscription/tenant where the AKS cluster will be hosted in

# will be created:
dockerBridgeAddress="172.17.0.1/16"
dnsServiceIp="192.168.0.10" 
serviceCidr="192.168.0.0/24"

# must exist before execution (deployment targets):
tenantId="6f077ee4-4736-4da8-9479-c9ba866a5c4d" # labsimon.onmicrosoft.com --> must be the tenant where server-app and client-app were created
subscriptionId="48006515-4d68-4a94-84a2-69da5d351c6f" 
targetResourceGroup="rg-AKS"
targetSubnetId="/subscriptions/${subscriptionId}/resourceGroups/rg-AKS/providers/Microsoft.Network/virtualNetworks/aks-vnet/subnets/aks-subnet"
attachedACR="simonslab"
workspaceid="/subscriptions/48006515-4d68-4a94-84a2-69da5d351c6f/resourcegroups/rg-virtual-dc/providers/microsoft.operationalinsights/workspaces/vdc-workspace" # add the workspace id you want your logs sent to

# copy from results of az-app-create.sh:
aksname="simonsDemoAKS"
serverApplicationId="c12921ab-5977-4e76-acee-8e07ae800e04"
serverApplicationSecret="0a5921de-be45-443a-bc70-2255ba0e2c03"
clientApplicationId="293a0d9e-4420-41ba-a284-bf20639f8ccc"

# service principal (must be in same AAD as your AKS cluster's subscription)
# when fetching aks-credentials, use your admin account from the tenant where your AKS cluster is located
SERVICE_PRINCIPAL_ID=$(az ad sp create-for-rbac --role="Contributor" \
    --scopes="/subscriptions/${subscriptionId}/resourceGroups/$targetResourceGroup" \
    --name "simonsK8_sp" \
    --query appId -o tsv)

SERVICE_PRINCIPAL_SECRET=$(az ad sp credential reset \
    --name $SERVICE_PRINCIPAL_ID \
    --credential-description "AKSPassword" \
    --query password -o tsv)

sleep 20

az aks create \
    --resource-group $targetResourceGroup \
    --name $aksname \
    --network-plugin azure \
    --vnet-subnet-id $targetSubnetId \
    --docker-bridge-address $dockerBridgeAddress \
    --dns-service-ip $dnsServiceIp \
    --service-cidr $serviceCidr \
    --generate-ssh-keys \
    --node-count 3 \
    --attach-acr $attachedACR \
    --enable-rbac \
    --aad-server-app-id $serverApplicationId \
    --aad-server-app-secret $serverApplicationSecret \
    --aad-client-app-id $clientApplicationId \
    --aad-tenant-id $tenantId \
    --enable-addons monitoring \
    --workspace-resource-id $workspaceid \
    --network-policy azure \
    --client-secret $SERVICE_PRINCIPAL_SECRET \
    --service-principal $SERVICE_PRINCIPAL_ID \
    --vm-set-type VirtualMachineScaleSets 
    

echo Do not forget to install flexvol to the cluster: kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml