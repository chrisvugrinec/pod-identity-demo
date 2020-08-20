AKS_CLUSTER=$1
AKS_RG=$2
KEYVAULT_NAME=$3

if [ "$#" -ne 3 ] ;
then
  echo "Usage: $0 AKS_CLUSTER AKS_RG AKV_NAME"
  echo ""
  echo "AKS Clusters:"
  az aks list -o table
  echo "AKVs:"
  az keyvault list -o table
  exit 1
fi

uaid=$(az aks show -g $AKS_RG -n $AKS_CLUSTER --query identityProfile.kubeletidentity.clientId -o tsv)

# set policy to access keys in your Key Vault
az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $uaid

# set policy to access secrets in your Key Vault
#az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $uaid
# set policy to access certs in your Key Vault
#az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $uaid

