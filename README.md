# pod-identity-demo

## Intro

Many great articles about AKS Pod Identity, this is more a note for myself...but feel free to use it, if you like it.
Links I have used are at the bottom.

AKS uses AAD on the following levels:

- Cluster level (MI/SP)
- Personal/Non personal accounts (kubectl)
- Application

Cluster and Personal/ Non Personal has to do with IAM related to cluster management and Usage (for eg accessing the API with kubectl)
Application can use AAD authentication in several ways, using the (managed) Pod identities is currently the recommendation.
Here you use an User Assigned Managed ID and link this to your APP/POD

In order to setup aad-pod-identies you need to deploy some CRDs, most notable:

- AzureIdentity
- AzureIdentityBinding
  
And you need to have 2 components which are responsible for acquiring a valid AAD token for your app:

- Node Managed Identity; A K8 Deamonset which act as an admission controller before a pod does a request to an azure resource. It orchestrates the ID retrieval and eventually passes the AAD authention token to the pod.
- Managed Identity Controller; A K8 deployment responsible for linking the Identities to the pod and the underlying VMSS and cleaning up when not relevant anymore

![Image of pod ID](https://raw.githubusercontent.com/chrisvugrinec/pod-identity-demo/master/images/pod-id.png)

1. The pod likes to access an Azure resource
2. The request is intercepted by the NMI which retrieves the assigned ID by querying the MIC using the pod ID
3. If there is an AzureIdentityBinding which uses the retrieved assigned ID we can proceed
4. NMI tries to get a valid token from AAD using the ADAL framework
5. The token is presented to the POD.app
6. The token is presented to the POD/app
7. With this token, the POD can now try to access the requested service (for eg Keyvault)...The service needs to be configured so that the found (managed) ID is able to access the service. 

## Cookbook

These are the steps to do it yourself so you can experiment with it.

### Create Infra

For this demo you will need the following Azure Infra components: AKS cluster, Keyvault. This demo uses a tiered setup into 2 layers. Terraform is used for the rollout and the State is stored on Azure Blob storage.

- get sources; ```git clone https://github.com/chrisvugrinec/pod-identity-demo.git```
- prepare Azure storage (for terraform state); ```cd infra``` change the variables in the ```1_setupTFStorage.sh``` script.
- create the storage: ```./1_setupTFStorage.sh*```
- set the ARM_ACCESS_KEY variable; ```export ARM_ACCESS_KEY= [ the storage key found in the previous step] ```
- setup tier 2, the network structure; ```cd tier_2``` change the variables.tf, naming and storage account settings
- rollout the network structure; ```terraform init; terraform plan; terraform apply```
- setup tier 3, AKS and Keyvault; ```cd tier_3``` change the variables.tf, naming and storage account settings
- rollout the demo app structure; ```terraform init; terraform plan; terraform apply```

### Setup POD Identity and App

- prepare demo; ```cd k8```
- assign proper roles to AKS managed Identity (Managed Identity Operator and Virtual Machine Contributor); ```./0_roleBindingAKSClusterID.sh AKS_CLUSTER AKS_RG```
- deploy required CRDs', Managed Identity Controller and Node Management Identity; ```./1_deployAdPodIdentity.sh```
- create and deploy AzureIdentity and AzureIdentityBindings (based on previous CRDs); ```./2_createCrd.sh AKS_CLUSTER AKS_RG IDENTITY_NAME```
- deploy the DEMO application; ```./3_deploy_demo.sh AKS_CLUSTER AKS_RG IDENTITY_NAME KEYVAULT_NAME```

You should be able to see the secret in the log file of the pod;

```kubectl logs -f demo-py```

This should correspond with the value set in the terraform rollout: ```see /infra/tier_3/app1-team/keyvault.tf```

## Links

- https://github.com/Azure/aad-pod-identity
- https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md
- https://csa-ocp-ger.github.io/unicorn/challenges.aadpodidentity.html
- https://cloudiqtech.com/implementing-azure-ad-pod-identity-in-aks-cluster/
- https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
- https://itnext.io/the-right-way-of-accessing-azure-services-from-inside-your-azure-kubernetes-cluster-14a335767680