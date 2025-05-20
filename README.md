
# 🚀 DevOps Pipeline with Terraform & ArgoCD

> Fully automated GitOps-based CI/CD pipeline using Terraform, Docker, Kubernetes (Minikube), and ArgoCD.  
> Built to simulate real-world infrastructure delivery using Infrastructure as Code and declarative Git-driven deployments.

---

## 🧠 Problem This Solves

Modern applications require repeatable, secure, and automated deployment workflows. Manual provisioning and inconsistent deployments can lead to downtime and configuration drift. This project automates infrastructure and application delivery using Terraform and GitOps (ArgoCD), enabling:
- Zero-touch Kubernetes deployments
- Version-controlled infrastructure
- Reproducible environments for rapid delivery

---

## 🎯 Goals

- Provision a local Kubernetes cluster with Terraform
- Deploy applications declaratively using GitOps via ArgoCD
- Use Docker to containerize a FastAPI app
- Enable CI workflows through GitHub Actions for infra and app
- Document architecture, testing, and secrets clearly

---

## 🛠️ Tech Stack

- **Infrastructure as Code**: Terraform
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Minikube)
- **GitOps/CD**: ArgoCD
- **CI Pipelines**: GitHub Actions
- **App Framework**: FastAPI (Python)
- **Secrets Management**: Kubernetes Secrets
- **Monitoring** *(optional)*: Prometheus, Grafana

---

## 🧱 Architecture Diagram

![Architecture](https://raw.githubusercontent.com/LordSesay/devops-pipeline-terraform-argocd/main/assets/architecture.png)

---

## 📂 Folder Structure

```
.
├── terraform/               # IaC for Minikube + ArgoCD setup
├── docker/                  # FastAPI Docker app
├── helm/                    # Helm chart for app deployment
├── manifests/               # Kubernetes raw YAMLs
├── argocd/                  # ArgoCD app + project manifests
├── .github/workflows/       # CI pipelines for Terraform & ArgoCD
├── scripts/                 # Bootstrap and secrets setup
├── testing/                 # Deployment and functional test scripts
├── ARCHITECTURE.md          # Deep dive on project flow
└── README.md
```

---

## ⚙️ How It Works

1. **Minikube Cluster Setup**  
   Run `minikube start --driver=docker` and apply Terraform to provision the cluster and install ArgoCD.

2. **Infrastructure Deployment**  
   GitHub Actions triggers `terraform.yml` on commit, applying infrastructure changes.

3. **GitOps with ArgoCD**  
   ArgoCD automatically syncs changes from GitHub, deploying the latest manifests/Helm charts.

4. **CI/CD Integration**  
   GitHub Actions builds Docker images and optionally syncs ArgoCD apps.

5. **Secure Deployment**  
   Secrets are injected via Kubernetes and managed with RBAC.

---

## 📌 Key Features

- 🔁 **GitOps-Driven Delivery**: Sync K8s deployments straight from your Git repo.
- 🛠️ **Modular Terraform**: Infrastructure is reproducible and environment-agnostic.
- 🐳 **Dockerized Microservices**: App is built and containerized using best practices.
- 🔐 **Secure Config**: Secrets injected safely; role-based access enforced.
- 🧪 **Testing Suite**: Local test scripts and CI tests for validation.

---

## 🔐 Secrets & Access

Sensitive config is stored as Kubernetes secrets.  
See: [`secrets-management.md`](./secrets-management.md)

---

## 🧪 Testing

Deployment validation scripts and suggestions can be found in [`testing/`](./testing/) and [`tests.md`](./tests.md).

---

## 📈 Future Enhancements

- ✅ Add Prometheus + Grafana metrics dashboard
- 🔐 RBAC + OAuth2 integration for ArgoCD
- ☁️ EKS migration version for AWS showcase
- 🔍 Add unit tests with pytest and CI hooks

---

## 💼 Business Use Case

> Enables DevOps teams to adopt GitOps workflows using familiar tools like Terraform and ArgoCD.  
> Accelerates deployments, reduces human error, and improves visibility into application state via a single source of truth — Git.

---

## 🔗 Connect

- 🧑‍💼 **Author**: [Malcolm Sesay](https://www.linkedin.com/in/malcolmsesay)
- 📁 **Portfolio**: [lordsesay.github.io/portfolio](https://lordsesay.github.io/portfolio)
- 🌐 **Live Demo**: *Minikube only (local access)*

---

## 📜 License

This project is licensed under the MIT License.
