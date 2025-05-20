# Secrets Management Strategy

This document outlines the approach for managing secrets in the DevOps pipeline.

## Kubernetes Secrets

Basic secrets are stored as Kubernetes Secrets and referenced in deployments:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: default
type: Opaque
data:
  DB_PASSWORD: cGFzc3dvcmQxMjM=  # base64 encoded
  API_KEY: YWJjZGVmMTIzNDU2Nzg5MA==  # base64 encoded
```

## Sealed Secrets

For GitOps workflows, we use Bitnami Sealed Secrets to encrypt secrets that can be safely stored in Git:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: mysecret
  namespace: default
spec:
  encryptedData:
    # These values are encrypted with the cluster's public key
    DB_PASSWORD: AgBy8hCM8FQIqC0sJwYZ9k3iOKbO5DnV7FeK3WwBTKr7
    API_KEY: AgCtr9EDxVNAhHWAzX9Lw3Pf1lm2DkJP+Zl9dI4k3Q==
```

## Setup Instructions

1. Install the Sealed Secrets controller:
```bash
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets sealed-secrets/sealed-secrets
```

2. Install kubeseal CLI:
```bash
# Linux
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.5/kubeseal-0.19.5-linux-amd64.tar.gz
tar -xvzf kubeseal-0.19.5-linux-amd64.tar.gz
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# macOS
brew install kubeseal

# Windows
# Download from https://github.com/bitnami-labs/sealed-secrets/releases
```

3. Create a sealed secret:
```bash
kubectl create secret generic app-secrets \
  --from-literal=DB_PASSWORD=password123 \
  --from-literal=API_KEY=abcdef1234567890 \
  --dry-run=client -o yaml | \
  kubeseal --format yaml > sealed-secret.yaml
```

4. Apply the sealed secret:
```bash
kubectl apply -f sealed-secret.yaml
```

## Environment Variables

Reference secrets in deployments:

```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: app-secrets
      key: DB_PASSWORD
```

## CI/CD Integration

In GitHub Actions workflows, use GitHub Secrets for sensitive values:

```yaml
steps:
- name: Deploy to Kubernetes
  env:
    KUBE_CONFIG: ${{ secrets.KUBE_CONFIG }}
  run: |
    echo "$KUBE_CONFIG" > kubeconfig.yaml
    export KUBECONFIG=kubeconfig.yaml
    kubectl apply -f manifests/
```