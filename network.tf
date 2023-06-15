resource "kubernetes_ingress_v1" "airflow" {
  wait_for_load_balancer = true
  # depends_on = [helm_release.airflow]
  metadata {
    name      = "airflow"
    namespace = var.airflow-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["airflow.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "airflow.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.airflow.metadata.0.name
              port {
                number = data.kubernetes_service.airflow.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_ingress_v1" "lakefs" {
  wait_for_load_balancer = true
  metadata {
    name      = "lakefs"
    namespace = var.lakefs-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["lakefs.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "lakefs.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.lakefs.metadata.0.name
              port {
                number = data.kubernetes_service.lakefs.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_ingress_v1" "superset" {
  wait_for_load_balancer = true
  metadata {
    name      = "superset"
    namespace = var.superset-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["superset.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "superset.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.superset.metadata.0.name
              port {
                number = data.kubernetes_service.superset.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_ingress_v1" "spark" {
  wait_for_load_balancer = true
  metadata {
    name      = "spark"
    namespace = var.spark-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["spark.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "spark.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.spark.metadata.0.name
              port {
                number = data.kubernetes_service.spark.spec.0.port.1.port
              }
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_ingress_v1" "neo4j" {
  wait_for_load_balancer = true
  metadata {
    name      = "neo4j"
    namespace = var.neo4j-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["neo4j.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "neo4j.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.neo4j.metadata.0.name
              port {
                number = data.kubernetes_service.neo4j.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_ingress_v1" "keycloak" {
  wait_for_load_balancer = true
  metadata {
    name      = "keycloak"
    namespace = var.keycloak-namespace
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = ["keycloak.${var.dns-name}"]
      secret_name = "amplify-lafia-cert-secret"
    }
    rule {
      host = "keycloak.${var.dns-name}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = data.kubernetes_service.keycloak.metadata.0.name
              port {
                number = data.kubernetes_service.keycloak.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}