# Crée le RG du backend
az group create -n rg-mar_3 -l westeurope

# Crée le storage account
az storage account create \
  -n tfstoragemar3 \
  -g rg-tfstate \
  -l westeurope \
  --sku Standard_LRS

# Récupère la clé
ACCOUNT_KEY=$(az storage account keys list -g rg-tfstate -n tfstateaccount --query '[0].value' -o tsv)

# Crée le container
az storage container create -n tfstate \
  --account-name tfstateaccount \
  --account-key $ACCOUNT_KEY
