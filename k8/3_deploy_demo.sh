AKS_CLUSTER=$1$KEYVAULT_NAME
AKS_RG=$2
IDENTITY_NAME=$3
KEYVAULT_NAME=$4


if [ "$#" -ne 4 ] ;
then
  echo "Usage: $0 AKS_CLUSTER AKS_RG IDENTITY_NAME KEYVAULT_NAME"
  echo ""
  echo "AKS Clusters:"
  az aks list -o table
  echo "----------------------------"
  echo "Keyvaults: "
  az keyvault list -o table
  exit 1
fi

#echo "make sure you remove the network ACL temporary"
#echo "value for secret: "
#read secret

#az keyvault secret set  -n demo-secret1 --value "$secret"  --vault-name $KEYVAULT_NAME

RESOURCE_GROUP=$(az aks show -n $AKS_CLUSTER -g $AKS_RG --query nodeResourceGroup -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: demo-py
  labels:
    aadpodidbinding: $IDENTITY_NAME
spec:
  containers:
  - name: demo-py
    image: cvugrinec/msid-demo:2.2
    env:
    - name: SUBSCRIPTION
      value: $SUBSCRIPTION_ID
    - name: RG
      value: $RESOURCE_GROUP
    - name: MSID
      value: $IDENTITY_NAME
    - name: KEY_VAULT_NAME
      value: $KEYVAULT_NAME
EOF
