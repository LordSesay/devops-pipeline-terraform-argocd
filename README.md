# DevOps Pipeline with Terraform & ArgoCD

[![CI Pipeline](https://github.com/LordSesay/devops-pipeline-terraform-argocd/actions/workflows/ci.yml/badge.svg)](https://github.com/LordSesay/devops-pipeline-terraform-argocd/actions/workflows/ci.yml)

A complete CI/CD pipeline using Terraform for infrastructure provisioning and ArgoCD for GitOps-based deployments.

## Project Stack

- **Terraform**: Infrastructure provisioning
- **ArgoCD**: GitOps for automated Kubernetes deployment
- **Kubernetes**: Container orchestration (Minikube or EKS)
- **Docker**: Application containerization

## Setup Instructions

### Prerequisites

- Docker installed
- Minikube or access to EKS cluster
- Terraform CLI
- kubectl CLI
- ArgoCD CLI (optional)

### Local Development

1. **Start Minikube**
   ```bash
   scripts/start-minikube.bat
   ```

2. **Install ArgoCD**
   ```bash
   scripts/setup-argocd.bat
   ```

3. **Deploy Application with ArgoCD**
   ```bash
   scripts/deploy-app.bat
   ```

4. **Test the Application**
   ```bash
   python scripts/test-app.py
   ```

## Project Structure

- `.github/workflows/`: CI/CD pipelines
- `argocd/`: ArgoCD application manifests
- `docker/`: Dockerfile and application code
- `helm/`: Helm charts for Kubernetes deployments
- `manifests/`: Kubernetes manifests
- `scripts/`: Utility scripts
- `terraform/`: Infrastructure as Code
- `tests/`: Testing framework

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for a detailed explanation of the pipeline architecture.

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## License

MIT