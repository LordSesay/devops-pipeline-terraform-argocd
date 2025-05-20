# Testing Guide for DevOps Pipeline

This guide provides step-by-step instructions for testing the DevOps pipeline locally.

## Prerequisites

- Docker installed and running
- Minikube installed
- kubectl installed
- Python installed (for running test scripts)

## Step 1: Start Minikube

Due to issues with the Terraform Minikube provider, we'll start Minikube directly:

```bash
# Windows
scripts\start-minikube.bat

# Linux/macOS
bash scripts/start-minikube.sh
```

## Step 2: Set Up ArgoCD

Install and configure ArgoCD:

```bash
# Windows
scripts\setup-argocd.bat

# Linux/macOS
bash scripts/setup-argocd.sh
```

This will:
- Create the ArgoCD namespace
- Install ArgoCD components
- Set up port forwarding
- Display the admin password

Access the ArgoCD UI at https://localhost:8080 with username `admin` and the displayed password.

## Step 3: Build and Deploy Application

Build the Docker image and deploy the application:

```bash
# Windows
scripts\deploy-app.bat

# Linux/macOS
bash scripts/deploy-app.sh
```

This will:
- Build the Docker image
- Load the image into Minikube
- Apply ArgoCD configurations
- Set up port forwarding for the application

## Step 4: Test the Application

Run the test script to verify the application is working correctly:

```bash
# Windows
python scripts\test-app.py

# Linux/macOS
python3 scripts/test-app.py
```

The script will test the following endpoints:
- `/` - Main endpoint
- `/health` - Health check endpoint
- `/info` - Application info endpoint

## Step 5: Make Changes and Test CI/CD

1. Make a change to the application code in `docker/app/main.py`
2. Rebuild and reload the Docker image:
   ```bash
   cd docker
   docker build -t myapp:latest .
   minikube image load myapp:latest
   ```
3. Observe ArgoCD automatically detecting and applying the changes
4. Run the test script again to verify the changes

## Troubleshooting

### ArgoCD Issues

If ArgoCD is not accessible:
```bash
kubectl get pods -n argocd
kubectl logs deployment/argocd-server -n argocd
```

### Application Issues

If the application is not accessible:
```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Port Forwarding Issues

If port forwarding is not working:
```bash
# Check if the service exists
kubectl get svc

# Try port forwarding again
kubectl port-forward svc/myapp 8080:8080
```