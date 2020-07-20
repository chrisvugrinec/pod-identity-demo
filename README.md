# pod-identity-demo

## Intro

Many great articles about AKS Pod Identity, this is more a note for myself...but feel free to use it, if you like it.
Links I have used are at the bottom.

Within ctx of AKS 3 ways of utilising AAD IAM, Cluster level (MI/SP), Personal/Non personal, Application. 
Cluster and Personal/ Non Personal has to do with IAM related to cluster management and Usage (for eg accessing the API with kubectl)
With Application you use an Assigned ID (MI/SP) and link this to your APP/POD; aad-pod-identities makes this link possible.

In order to setup aad-pod-identies you need to deploy some CRDs, most notable:

- AzureIdentity
- AzureIdentityBinding
  
And you need to have 2 components which are responsible for acquiring a valid AAD token for your app:

- Managed Identity Controller; A K8 deployment responsible for linking the Identities to the pod and the underlying VMSS and cleaning up when not relevant anymore
- Node Managed Identity; A K8 Deamonset responsible to authorisation of the pod. It will use the identity from the MIC and will generate an AAD token through an ADAL request.

![Image of pod ID](https://raw.githubusercontent.com/chrisvugrinec/pod-identity-demo/master/images/pod-id.png)








az role assignment create
  --role "Managed Identity Operator"
  --assignee <aks_service_principal_id_here>
  --scope <azure_identitys_id>

## Links

- https://github.com/Azure/aad-pod-identity
- https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md
- https://csa-ocp-ger.github.io/unicorn/challenges.aadpodidentity.html
- https://cloudiqtech.com/implementing-azure-ad-pod-identity-in-aks-cluster/
- https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
- https://itnext.io/the-right-way-of-accessing-azure-services-from-inside-your-azure-kubernetes-cluster-14a335767680