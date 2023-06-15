data "kubernetes_service" "ingress" {

  depends_on = [helm_release.ingress-nginx]

  metadata {
    name      = "ingress-nginx-controller"
    namespace = var.ingress-namespace
  }
}



data "digitalocean_droplet" "amplify-lafia" {
  id = digitalocean_kubernetes_cluster.amplify-lafia.node_pool[0].nodes[0].droplet_id
}



data "kubernetes_service" "postgres" {

  depends_on = [helm_release.postgres]

  metadata {
    name      = var.postgres-service-name
    namespace = var.postgres-namespace
  }
}



data "kubernetes_service" "airflow" {

  depends_on = [helm_release.airflow]

  metadata {
    name      = var.airflow-service-name
    namespace = var.airflow-namespace
  }
}



data "kubernetes_service" "lakefs" {

  depends_on = [helm_release.lakefs]

  metadata {
    name      = var.lakefs-service-name
    namespace = var.lakefs-namespace
  }
}



data "kubernetes_service" "superset" {

  depends_on = [helm_release.superset]

  metadata {
    name      = var.superset-service-name
    namespace = var.superset-namespace
  }
}



data "kubernetes_service" "spark" {

  depends_on = [helm_release.spark]

  metadata {
    name      = var.spark-service-name
    namespace = var.spark-namespace
  }
}



data "kubernetes_service" "neo4j" {

  depends_on = [helm_release.neo4j]

  metadata {
    name      = var.neo4j-service-name
    namespace = var.neo4j-namespace
  }
}



data "kubernetes_service" "keycloak" {

  depends_on = [helm_release.keycloak]

  metadata {
    name      = var.keycloak-service-name
    namespace = var.keycloak-namespace
  }
}



# data "kubernetes_service" "yugabyte" {

#   depends_on = [helm_release.yugabyte]

#   metadata {
#     name      = var.yugabyte-service-name
#     namespace = var.yugabyte-namespace
#   }
# }
