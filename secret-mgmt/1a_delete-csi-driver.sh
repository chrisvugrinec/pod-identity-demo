#!/bin/bash

kubectl delete -f deploy/rbac-secretproviderclass.yaml # update the namespace of the secrets-store-csi-driver ServiceAccount
kubectl delete -f deploy/csidriver.yaml
kubectl delete -f deploy/secrets-store.csi.x-k8s.io_secretproviderclasses.yaml
kubectl delete -f deploy/secrets-store.csi.x-k8s.io_secretproviderclasspodstatuses.yaml
kubectl delete -f deploy/secrets-store-csi-driver.yaml 

