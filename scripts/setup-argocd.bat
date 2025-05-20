@echo off
echo 🚀 Setting up ArgoCD...

REM Check if Minikube is running
minikube status | findstr "Running"
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Minikube is not running. Starting Minikube...
    minikube start --driver=docker
)

REM Create ArgoCD namespace
kubectl create namespace argocd

REM Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo ⏳ Waiting for ArgoCD to be ready...
echo This may take a few minutes...

REM Wait for ArgoCD server to be ready (60 seconds)
timeout /t 60

REM Check if ArgoCD server is running
kubectl get pods -n argocd | findstr "argocd-server"
if %ERRORLEVEL% NEQ 0 (
    echo ❌ ArgoCD server is not running. Please check the logs:
    kubectl get pods -n argocd
    exit /b 1
)

REM Port forward ArgoCD server
echo 🔌 Setting up port forwarding for ArgoCD server...
start cmd /c "kubectl port-forward svc/argocd-server -n argocd 8080:443"

REM Get ArgoCD admin password
echo 🔑 Retrieving ArgoCD admin password...
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > encoded_password.txt
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to retrieve ArgoCD password. Using default password: admin
    echo admin > decoded_password.txt
) else (
    certutil -decode encoded_password.txt decoded_password.txt
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to decode password. Using default password: admin
        echo admin > decoded_password.txt
    )
)

set /p ARGOCD_PASSWORD=<decoded_password.txt
if exist encoded_password.txt del encoded_password.txt
if exist decoded_password.txt del decoded_password.txt

echo ✅ ArgoCD setup complete!
echo 🌐 Access ArgoCD UI at: https://localhost:8080
echo 🔐 Username: admin
echo 🔐 Password: %ARGOCD_PASSWORD%