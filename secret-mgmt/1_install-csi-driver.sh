#!/bin/bash

# https://github.com/Azure/secrets-store-csi-driver-provider-azure/tree/master/docs
# https://github.com/Azure/secrets-store-csi-driver-provider-azure/tree/master/examples
# official documentation: https://docs.microsoft.com/en-us/azure/key-vault/general/key-vault-integrate-kubernetes
kubectl apply -f deploy/rbac-secretproviderclass.yaml # update the namespace of the secrets-store-csi-driver ServiceAccount
kubectl apply -f deploy/csidriver.yaml
kubectl apply -f deploy/secrets-store.csi.x-k8s.io_secretproviderclasses.yaml
kubectl apply -f deploy/secrets-store.csi.x-k8s.io_secretproviderclasspodstatuses.yaml
kubectl apply -f deploy/secrets-store-csi-driver.yaml 

