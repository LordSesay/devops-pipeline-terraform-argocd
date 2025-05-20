#!/bin/bash

# Script to set up secrets management for the application
# This script demonstrates how to create and manage Kubernetes secrets

# Create namespace if it doesn't exist
kubectl create namespace app-namespace --dry-run=client -o yaml | kubectl apply -f -

# Create a generic secret from literal values
kubectl create secret generic app-credentials \
  --from-literal=db-password=password123 \
  --from-literal=api-key=abcdef1234567890 \
  --namespace=app-namespace \
  --dry-run=client -o yaml | kubectl apply -f -

# Create a secret from files
# kubectl create secret generic app-certs \
#   --from-file=./certs/tls.crt \
#   --from-file=./certs/tls.key \
#   --namespace=app-namespace \
#   --dry-run=client -o yaml | kubectl apply -f -

echo "Secrets created successfully!"

# Optional: Install sealed-secrets controller
# helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
# helm install sealed-secrets sealed-secrets/sealed-secrets