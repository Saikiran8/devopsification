provider "google" {
  project = var.project_id  
  region  = var.project_region
  credentials = file("C:/Users/kollo/Downloads/kubernetes-434604-073a82178589.json")         
}

resource "google_container_cluster" "primary" {
  name               = var.gke_cluster 
  location           = var.cluster_location 
  initial_node_count = 1
    deletion_protection = false
  node_config {
    machine_type = var.machine_type 
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 20
  }
}
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  # host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "k8s" {
  metadata {
    name = "k8s"
  }
}

# Create the secret in Google Secret Manager
resource "google_secret_manager_secret" "docker_auth_new"{
  secret_id  = "dockerhub-secret"  # Name of the secret
  project    = var.project_id  # Your GCP project ID

  replication {
    auto {
    }  # Use automatic replication across regions
  }
}

# Add a version of the secret (the actual Docker credentials)
resource "google_secret_manager_secret_version" "docker_auth_version" {
  secret      = google_secret_manager_secret.docker_auth_new.id  # Reference the secret
  secret_data = base64encode(jsonencode({
    username = var.dockerhub_username
    password = var.dockerhub_password
    email    = var.dockerhub_email
    auth     = base64encode("${var.dockerhub_username}:${var.dockerhub_password}")
  }))  # Store Docker credentials in the secret
}

# Fetch the secret version to create a Kubernetes secret
data "google_secret_manager_secret_version" "docker_auth_version" {
  secret  = google_secret_manager_secret.docker_auth_new.secret_id  # Name of the secret
  project = var.project_id
}

# Create a Kubernetes Secret using the fetched secret data
resource "kubernetes_secret" "dockerhub_secret" {
  metadata {
    name      = "dockerhub-secret"
    namespace = "k8s"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = base64encode(jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = var.dockerhub_username
          password = var.dockerhub_password
          email    = var.dockerhub_email
          auth     = base64encode("${var.dockerhub_username}:${var.dockerhub_password}")
        }
      }
    }))
  }
}


resource "kubernetes_config_map" "react_app_config" {
  metadata {
    name      = "java-config"
    namespace = "k8s"
  }

  data = {
    REACT_APP_API_URL = "http://java-service.k8s.svc.cluster.local:8080"
  }
}

resource "kubernetes_deployment" "react_app" {
  metadata {
    name      = "react-app"
    namespace = "k8s"
    labels = {
      app = "react-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "react-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "react-app"
        }
      }

      spec {
        image_pull_secrets {
          # name = kubernetes_secret.docker_auth.metadata[0].name
          name = kubernetes_secret.dockerhub_secret.metadata[0].name
        }
        container {
          name  = "react-container"
          image = "saiki8/sa-react:latest"

          # If using ConfigMap
          env {
            name = "REACT_APP_API_URL"
            value_from {
              config_map_key_ref {
                name = "java-config"
                key  = "REACT_APP_API_URL"
              }
            }
          }

          # Or hardcode the value directly (optional)
          # env {
          #   name  = "REACT_APP_API_URL"
          #   value = "http://10.244.0.15:8080"
          # }

          port {
            container_port = 80
          }

          resources {
            limits = {
              memory = "128Mi"
              cpu    = "500m"
            }
          }
        }
      }
    }
  }
}
