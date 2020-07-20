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

- Node Managed Identity; A K8 Deamonset which act as an admission controller before a pod does a request to an azure resource. It orchestrates the ID retrieval and eventually passes the AAD authention token to the pod.
- Managed Identity Controller; A K8 deployment responsible for linking the Identities to the pod and the underlying VMSS and cleaning up when not relevant anymore

![Image of pod ID](https://raw.githubusercontent.com/chrisvugrinec/pod-identity-demo/master/images/pod-id.png)

1. The pod like to access a resource
2. The request is intercepted by the NMI which retrieved the assigned ID by querying the MIC
3. If the is an AzureIdentityBinding by using the assigned ID we can proceed
4. NMI tries to get a valid token from AAD using the ADAL framework
5. The token is presented to the POD.app
6. The token is presented to the POD/app
7. With this token, the POD can now try to access the requested service (for eg Keyvault)...The service needs to be configured in such a way that found (managed) ID is able to access the service

## Cookbook

These are the steps to do it yourself so you can experiment with it.

### Create Infra

For this demo you will need the following Azure Infra components: AKS cluster, Keyvault. This demo uses a tiered setup into 2 layers. Terraform is used for the rollout and the State is stored on Azure Blob storage.

### Setup POD Identity and App


## Links

- https://github.com/Azure/aad-pod-identity
- https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md
- https://csa-ocp-ger.github.io/unicorn/challenges.aadpodidentity.html
- https://cloudiqtech.com/implementing-azure-ad-pod-identity-in-aks-cluster/
- https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
- https://itnext.io/the-right-way-of-accessing-azure-services-from-inside-your-azure-kubernetes-cluster-14a335767680