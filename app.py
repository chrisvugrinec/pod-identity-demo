import os
from msrestazure.azure_active_directory import MSIAuthentication
from azure.mgmt.resource import ResourceManagementClient, SubscriptionClient
from azure.keyvault.secrets import SecretClient
from azure.identity import ManagedIdentityCredential


def get_keyvault_secret():
  credentials =  ManagedIdentityCredential(
    msi_res_id='/subscriptions/'+os.environ.get('SUBSCRIPTION')+'/resourceGroups/'+os.environ.get('RG')+'/providers/Microsoft.ManagedIdentity/userAssignedIdentities/'+os.environ.get('MSID')
  )
  secret_client = SecretClient(vault_url="https://"+os.environ.get('KEY_VAULT_NAME')+".vault.azure.net", credential=credentials)
  secret = secret_client.get_secret("demo-secret1")
  print("SECRET IS: "+secret.value)


def get_sqlserver_value():
  credentials2 =  ManagedIdentityCredential(
    msi_res_id='/subscriptions/'+os.environ.get('SUBSCRIPTION')+'/resourceGroups/'+os.environ.get('RG')+'/providers/Microsoft.ManagedIdentity/userAssignedIdentities/'+os.environ.get('MSID')
  )
  
  secret_client = SecretClient(vault_url="https://"+os.environ.get('KEY_VAULT_NAME')+".vault.azure.net", credential=credentials2)
  secret = secret_client.get_secret("demo-secret1")
  print("SECRET IS: "+secret.value)

if __name__ == "__main__":
  get_keyvault_secret()
