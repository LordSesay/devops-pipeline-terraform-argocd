#!/bin/bash

# Bootstrap script for setting up the DevOps pipeline

# Exit on error
set -e

echo "🚀 Starting DevOps Pipeline bootstrap..."

# Check prerequisites
echo "📋 Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Aborting."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform is required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl is required but not installed. Aborting."; exit 1; }
command -v minikube >/dev/null 2>&1 || { echo "❌ Minikube is required but not installed. Aborting."; exit 1; }

echo "✅ All prerequisites satisfied."

# Initialize and apply Terraform
echo "🔧 Setting up infrastructure with Terraform..."
cd ../terraform
terraform init
terraform apply -auto-approve

# Wait for Minikube to be ready
echo "⏳ Waiting for Minikube to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Install ArgoCD
echo "📦 Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Port forward ArgoCD server
echo "🔌 Setting up port forwarding for ArgoCD server..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
PORT_FORWARD_PID=$!

# Get ArgoCD admin password
echo "🔑 Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Admin Password: $ARGOCD_PASSWORD"

# Build and load Docker image
echo "🐳 Building Docker image..."
cd ../docker
docker build -t myapp:latest .
minikube image load myapp:latest

# Apply ArgoCD applications
echo "🚢 Deploying applications with ArgoCD..."
cd ../argocd
kubectl apply -f project.yaml
kubectl apply -f application.yaml

echo "✅ Bootstrap complete! Your DevOps pipeline is ready."
echo "🌐 Access ArgoCD UI at: https://localhost:8080"
echo "🔐 Username: admin"
echo "🔐 Password: $ARGOCD_PASSWORD"

# Cleanup port forwarding
kill $PORT_FORWARD_PID