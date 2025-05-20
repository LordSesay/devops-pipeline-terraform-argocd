# Troubleshooting Guide

This guide addresses common issues encountered when setting up the DevOps pipeline.

## Minikube Issues

### Kubernetes Version Mismatch

**Error:**
```
🙈  Exiting due to K8S_DOWNGRADE_UNSUPPORTED: Unable to safely downgrade existing Kubernetes v1.32.0 cluster to v1.28.3
```

**Solution:**
Use the existing Kubernetes version instead of trying to downgrade:
```bash
minikube start --driver=docker --cpus=2 --memory=4096mb
```

### Minikube Not Running

**Error:**
```
Unable to connect to the server: dial tcp 127.0.0.1:xxxxx: connectex: No connection could be made
```

**Solution:**
Start Minikube:
```bash
minikube start
```

## Docker Issues

### Dockerfile Not Found

**Error:**
```
ERROR: failed to solve: failed to read dockerfile: open Dockerfile: no such file or directory
```

**Solution:**
Ensure you're in the correct directory:
```bash
cd /d "%~dp0..\docker"
```

Create a Dockerfile if it doesn't exist:
```
FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 8080

CMD ["python", "main.py"]
```

## ArgoCD Issues

### ArgoCD Configuration Files Not Found

**Error:**
```
error: the path "project.yaml" does not exist
error: the path "application.yaml" does not exist
```

**Solution:**
Create the necessary files:
```bash
cd /d "%~dp0..\argocd"
# Create project.yaml and application.yaml
```

### ArgoCD Password Retrieval Failed

**Error:**
```
Unable to connect to the server
DecodeFile returned The data is invalid
```

**Solution:**
Ensure ArgoCD is properly installed and running:
```bash
kubectl get pods -n argocd
```

## Kubernetes Issues

### Service Not Found

**Error:**
```
error: services "myapp" not found
```

**Solution:**
Create the service:
```bash
kubectl create deployment myapp --image=myapp:latest --port=8080
kubectl expose deployment myapp --port=8080
```

## Testing Issues

### Connection Refused

**Error:**
```
Connection refused when accessing http://localhost:8080
```

**Solution:**
Ensure port forwarding is active:
```bash
kubectl port-forward svc/myapp 8080:8080
```

Check if the pod is running:
```bash
kubectl get pods
```