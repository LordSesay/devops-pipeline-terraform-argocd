terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "~> 0.4.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "minikube" {
  kubernetes_version = "v1.28.3"
  iso_url = "https://github.com/kubernetes/minikube/releases/download/v1.32.0/minikube-v1.32.0-amd64.iso"
}

provider "kubernetes" {
  host                   = minikube_cluster.minikube_docker.host
  client_certificate     = base64decode(minikube_cluster.minikube_docker.client_certificate)
  client_key             = base64decode(minikube_cluster.minikube_docker.client_key)
  cluster_ca_certificate = base64decode(minikube_cluster.minikube_docker.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "minikube"
    args        = ["kubectl", "config", "view", "--raw"]
  }

  experiments {
    manifest_resource = true
  }

  timeouts {
    create = "30m"
    read   = "15m"
    update = "30m"
    delete = "30m"
  }
}

resource "minikube_cluster" "minikube_docker" {
  driver       = "docker"
  cluster_name = "DevOps-Pipeline"
  
  cpus    = 2
  memory  = "4096mb"
  
  container_runtime = "containerd"
  cache_images = true
  
  addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "metrics-server"
  ]
  
  extra_config = [
    "kubelet.serialize-image-pulls=false",
    "kubeadm.pod-network-cidr=10.244.0.0/16"
  ]

  lifecycle {
    prevent_destroy = true
  }
}