# Pre-Requisites
az login --tenant 72f988bf-86f1-41af-91ab-2d7cd011db47
az account set --subscription "Microsoft Azure Internal Consumption"
# az upgrade
# az extensionn +add --name containerapp --upgrade

# az provider register --namepsace Microsoft.App
# az provider register --namepsace Microsoft.OperationalInsights

. "$PSScriptRoot\variables.ps1"



$ACR_NAME="acaalbums"+$GITHUB_USERNAME

az group create `
  --name $RESOURCE_GROUP `
  --location "$LOCATION"

az acr create `
    --resource-group $RESOURCE_GROUP `
  --name $ACR_NAME `
  --sku Basic `
  --admin-enabled true

  az acr create `
  --resource-group $RESOURCE_GROUP `
  --name $ACR_NAME `
  --sku Basic `
  --admin-enabled true

  cd ..
  cd code/code-to-cloud/src
  az acr build --registry $ACR_NAME --image $API_NAME .
 

  az containerapp env create `
  --name $ENVIRONMENT `
  --resource-group $RESOURCE_GROUP `
  --location $LOCATION

  az containerapp create `
  --name $API_NAME `
  --resource-group $RESOURCE_GROUP `
  --environment $ENVIRONMENT `
  --image "$ACR_NAME.azurecr.io/$API_NAME" `
  --target-port 3500 `
  --ingress 'external' `
  --registry-server "$ACR_NAME.azurecr.io" `
  --query configuration.ingress.fqdn  