#!/bin/bash

# Script to start Minikube directly instead of using Terraform
# This is a workaround for ISO download issues

echo "🚀 Starting Minikube manually..."

# Start Minikube with Docker driver
minikube start --driver=docker \
  --cpus=2 \
  --memory=4096mb \
  --kubernetes-version=v1.28.3 \
  --addons=ingress,metrics-server,default-storageclass,storage-provisioner

# Verify Minikube is running
minikube status

echo "✅ Minikube started successfully!"
echo "📋 Now you can continue with the rest of the deployment:"
echo "1. Install ArgoCD"
echo "2. Build and deploy your application"