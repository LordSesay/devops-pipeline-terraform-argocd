@echo off
echo 🚀 Building and deploying application...

REM Navigate to correct directory using absolute path
cd /d "%~dp0..\docker"

REM Check if Dockerfile exists
if not exist "Dockerfile" (
    echo ❌ Dockerfile not found in %CD%
    exit /b 1
)

REM Build Docker image
echo 🔨 Building Docker image...
docker build -t myapp:latest .

REM Load image into Minikube
echo 📦 Loading image into Minikube...
minikube image load myapp:latest

REM Apply ArgoCD configurations
echo 🔄 Applying ArgoCD configurations...
cd /d "%~dp0..\argocd"

REM Check if ArgoCD files exist
if not exist "project.yaml" (
    echo ❌ project.yaml not found in %CD%
    echo 📝 Creating basic ArgoCD project file...
    echo apiVersion: argoproj.io/v1alpha1 > project.yaml
    echo kind: AppProject >> project.yaml
    echo metadata: >> project.yaml
    echo   name: myproject >> project.yaml
    echo   namespace: argocd >> project.yaml
    echo spec: >> project.yaml
    echo   description: My application project >> project.yaml
    echo   sourceRepos: >> project.yaml
    echo   - '*' >> project.yaml
    echo   destinations: >> project.yaml
    echo   - namespace: '*' >> project.yaml
    echo     server: '*' >> project.yaml
    echo   clusterResourceWhitelist: >> project.yaml
    echo   - group: '*' >> project.yaml
    echo     kind: '*' >> project.yaml
)

if not exist "application.yaml" (
    echo ❌ application.yaml not found in %CD%
    echo 📝 Creating basic ArgoCD application file...
    echo apiVersion: argoproj.io/v1alpha1 > application.yaml
    echo kind: Application >> application.yaml
    echo metadata: >> application.yaml
    echo   name: myapp >> application.yaml
    echo   namespace: argocd >> application.yaml
    echo spec: >> application.yaml
    echo   project: default >> application.yaml
    echo   source: >> application.yaml
    echo     repoURL: https://github.com/LordSesay/devops-pipeline-terraform-argocd.git >> application.yaml
    echo     targetRevision: HEAD >> application.yaml
    echo     path: helm/myapp >> application.yaml
    echo   destination: >> application.yaml
    echo     server: https://kubernetes.default.svc >> application.yaml
    echo     namespace: default >> application.yaml
    echo   syncPolicy: >> application.yaml
    echo     automated: >> application.yaml
    echo       prune: true >> application.yaml
    echo       selfHeal: true >> application.yaml
)

REM Apply ArgoCD configurations
kubectl apply -f project.yaml
kubectl apply -f application.yaml

REM Create a basic deployment if needed
cd /d "%~dp0..\manifests"
if not exist "deployment.yaml" (
    echo ❌ deployment.yaml not found in %CD%
    echo 📝 Creating basic deployment...
    kubectl create deployment myapp --image=myapp:latest --port=8080 --dry-run=client -o yaml > deployment.yaml
    kubectl apply -f deployment.yaml
)

REM Create a service if needed
if not exist "service.yaml" (
    echo ❌ service.yaml not found in %CD%
    echo 📝 Creating basic service...
    kubectl expose deployment myapp --port=8080 --dry-run=client -o yaml > service.yaml
    kubectl apply -f service.yaml
)

REM Port forward the application
echo 🔌 Setting up port forwarding for the application...
start cmd /c "kubectl port-forward svc/myapp 8080:8080"

echo ✅ Application deployed!
echo 🌐 Access the application at: http://localhost:8080
echo 🧪 Run the test script to verify the application is working correctly