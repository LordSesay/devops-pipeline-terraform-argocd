@echo off
echo 🚀 Starting Minikube manually...

REM Start Minikube with Docker driver - using the existing version
minikube start --driver=docker ^
  --cpus=2 ^
  --memory=4096mb ^
  --addons=ingress,metrics-server,default-storageclass,storage-provisioner

REM Verify Minikube is running
minikube status

echo ✅ Minikube started successfully!
echo 📋 Now you can continue with the rest of the deployment:
echo 1. Install ArgoCD
echo 2. Build and deploy your application