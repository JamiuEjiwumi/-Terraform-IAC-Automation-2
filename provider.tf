terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.26.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.17.0"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.18.0"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}



provider "digitalocean" {
  # Configuration options

  token = var.digitalocean_token

  spaces_access_id = var.SPACES_ACCESS_ID

  spaces_secret_key = var.SPACES_SECRET_KEY

}



provider "helm" {
  # Configuration options
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.amplify-lafia.endpoint
    token                  = digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].cluster_ca_certificate)
  }
  experiments {
    manifest = "true"
  }
}



provider "kubernetes" {
  # Configuration options
  host                   = digitalocean_kubernetes_cluster.amplify-lafia.endpoint
  token                  = digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].cluster_ca_certificate)
}



provider "postgresql" {
  host            = data.digitalocean_droplet.amplify-lafia.ipv4_address
  port            = data.kubernetes_service.postgres.spec.0.port.0.node_port
  database        = var.lakefs-namespace
  username        = var.amplify-lafia-admin
  password        = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  sslmode         = "disable"
  connect_timeout = 15
}



provider "kubectl" {
  host                   = digitalocean_kubernetes_cluster.amplify-lafia.endpoint
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].cluster_ca_certificate)
  token                  = digitalocean_kubernetes_cluster.amplify-lafia.kube_config[0].token
  load_config_file       = false
}
