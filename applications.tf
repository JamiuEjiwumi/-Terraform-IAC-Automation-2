resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.4.2"
  namespace        = var.ingress-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
  values           = ["${file("./charts/ingress/ingress.yaml")}"]
}



resource "helm_release" "postgres" {
  name             = "postgres"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "postgresql"
  version          = "12.1.14"
  namespace        = var.postgres-namespace
  create_namespace = true
  wait             = true
  depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
  timeout          = 500
  values           = ["${file("./charts/postgres/postgres.yaml")}"]

  set_sensitive {
    name  = "global.postgresql.auth.postgresPassword"
    value = var.POSTGRES_ADMIN_PASSWORD
  }

  set {
    name  = "global.postgresql.auth.username"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name  = "global.postgresql.auth.password"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  set {
    name  = "global.postgresql.auth.database"
    value = var.lakefs-namespace
  }
}



resource "postgresql_database" "airflow" {
  name       = "airflow"
  depends_on = [helm_release.postgres]
}



resource "postgresql_database" "superset" {
  name       = "superset"
  depends_on = [helm_release.postgres]
}



resource "postgresql_database" "keycloak" {
  name       = "keycloak"
  depends_on = [helm_release.postgres]
}



resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.airflow-namespace
  }
}



resource "kubernetes_secret_v1" "airflow" {
  metadata {
    name      = "airflow-ssh-secret"
    namespace = var.airflow-namespace
  }
  data = {
    "gitSshKey" = file("${path.module}/files/amplify-lafia")
  }

  # type = "kubernetes.io/ssh-auth"
}



resource "helm_release" "airflow" {
  name             = "airflow"
  repository       = "https://airflow.apache.org/"
  chart            = "airflow"
  version          = "1.8.0"
  namespace        = var.airflow-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [postgresql_database.airflow, kubernetes_secret_v1.airflow]
  values           = ["${file("./charts/airflow/airflow.yaml")}"]

  set {
    name  = "data.metadataConnection.user"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name  = "data.metadataConnection.pass"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  set_sensitive {
    name  = "data.metadataConnection.host"
    value = "postgres-postgresql.postgres.svc.cluster.local"
  }

  set {
    name  = "data.metadataConnection.db"
    value = var.airflow-namespace
  }

  set_sensitive {
    name  = "webserverSecretKey"
    value = var.WEB_SERVER_SECRET_KEY
  }

  set {
    name  = "webserver.defaultUser.username"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name  = "webserver.defaultUser.email"
    value = var.admin-email
  }

  set {
    name  = "webserver.defaultUser.firstName"
    value = var.admin-first-name
  }

  set {
    name  = "webserver.defaultUser.lastName"
    value = var.admin-last-name
  }

  set_sensitive {
    name  = "webserver.defaultUser.password"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }
}



resource "helm_release" "lakefs" {
  name             = "lakefs"
  repository       = "https://charts.lakefs.io"
  chart            = "lakefs"
  version          = "0.8.8"
  namespace        = var.lakefs-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [data.kubernetes_service.postgres]
  values           = ["${file("./charts/lakefs/lakefs.yaml")}"]

  set {
    name  = "kv_upgrade"
    value = true
  }

  set_sensitive {
    name  = "secrets.databaseConnectionString"
    value = "postgresql://${var.amplify-lafia-admin}:${var.AMPLIFY_LAFIA_ADMIN_PASSWORD}@${data.digitalocean_droplet.amplify-lafia.ipv4_address}:${data.kubernetes_service.postgres.spec.0.port.0.node_port}/${var.lakefs-namespace}"
  }

  set_sensitive {
    name  = "secrets.authEncryptSecretKey"
    value = var.LAKEFS_AUTH_ENCRYPT_SECRET_KEY
  }
}



resource "helm_release" "superset" {
  name             = "superset"
  repository       = "https://apache.github.io/superset"
  chart            = "superset"
  version          = "0.8.5"
  namespace        = var.superset-namespace
  create_namespace = true
  wait             = true
  depends_on       = [postgresql_database.superset]
  timeout          = 500
  values           = ["${file("./charts/superset/superset.yaml")}"]

  set {
    name  = "supersetNode.replicaCount"
    value = 2
  }

  set {
    name  = "supersetWorker.replicaCount"
    value = 2
  }

  set_sensitive {
    name  = "supersetNode.connections.db_host"
    value = "postgres-postgresql.postgres.svc.cluster.local"
  }

  set {
    name  = "supersetNode.connections.db_user"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name  = "supersetNode.connections.db_pass"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  set {
    name  = "supersetNode.connections.db_name"
    value = var.superset-namespace
  }

  set {
    name  = "init.adminUser.username"
    value = var.amplify-lafia-admin
  }

  set {
    name  = "init.adminUser.firstname"
    value = var.admin-first-name
  }

  set {
    name  = "init.adminUser.lastname"
    value = var.admin-last-name
  }

  set_sensitive {
    name  = "init.adminUser.email"
    value = var.admin-email
  }

  set_sensitive {
    name  = "init.adminUser.password"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }
}



resource "helm_release" "spark" {
  name             = "spark"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "spark"
  version          = "6.3.16"
  namespace        = var.spark-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
  values           = ["${file("./charts/spark-cluster/spark-cluster.yaml")}"]
}



resource "helm_release" "neo4j" {
  name             = "neo4j"
  repository       = "https://helm.neo4j.com/neo4j"
  chart            = "neo4j"
  version          = "5.4.0"
  namespace        = var.neo4j-namespace
  create_namespace = true
  wait             = true
  depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
  timeout          = 500
  values           = ["${file("./charts/neo4j/neo4j.yaml")}"]

  set_sensitive {
    name  = "neo4j.password"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  set {
    name  = "volumes.data.defaultStorageClass.requests.storage"
    value = "10Gi"
  }


  set {
    name  = "neo4j.resources.cpu"
    value = "2000m"
  }

  set {
    name  = "neo4j.resources.memory"
    value = "5Gi"
  }
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.11.0"
  namespace        = var.cert-manager-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
  values           = ["${file("./charts/cert-manager/cert-manager.yaml")}"]

  set {
    name  = "installCRDs"
    value = true
  }
}



resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "keycloak"
  version          = "14.2.0"
  namespace        = var.keycloak-namespace
  create_namespace = true
  wait             = true
  timeout          = 500
  depends_on       = [helm_release.neo4j]
  values           = ["${file("./charts/keycloak/keycloak.yaml")}"]

  set {
    name = "auth.adminUser"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name = "auth.adminPassword"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  set_sensitive {
    name = "postgresql.auth.postgresPassword"
    value = var.POSTGRES_ADMIN_PASSWORD
  }

  set_sensitive {
    name = "postgresql.auth.username"
    value = var.amplify-lafia-admin
  }

  set_sensitive {
    name = "postgresql.auth.password"
    value = var.AMPLIFY_LAFIA_ADMIN_PASSWORD
  }

  # set {
  #   name = "externalDatabase.host"
  #   value = "yb-tservers.database.svc.cluster.local"
  # }

  # set {
  #   name = "externalDatabase.port"
  #   value = data.kubernetes_service.yugabyte-tservers.spec.0.port.7.port
  # }

  # set {
  #   name = "externalDatabase.user"
  #   value = "admin"
  # }

  # set {
  #   name = "externalDatabase.database"
  #   value = "keycloak-talentsphere"
  # }

  # set_sensitive {
  #   name = "externalDatabase.password"
  #   value = var.POSTGRES_ADMIN_PASSWORD
  # }
  
  set {
    name = "externalDatabase.host"
    value = "postgres-postgresql.postgres.svc.cluster.local"
  }

  set {
    name = "externalDatabase.port"
    value = data.kubernetes_service.postgres.spec.0.port.0.node_port
  }

  set {
    name = "externalDatabase.user"
    value = var.amplify-lafia-admin
  }

  set {
    name = "externalDatabase.database"
    value = var.keycloak-namespace
  }

  set_sensitive {
    name = "externalDatabase.password"
    value = var.POSTGRES_ADMIN_PASSWORD
  }
}



# resource "helm_release" "rabbitmq" {
#   name             = "rabbitmq"
#   repository       = "https://charts.bitnami.com/bitnami"
#   chart            = "rabbitmq"
#   version          = "11.10.0"
#   namespace        = var.rabbitmq-namespace
#   create_namespace = true
#   wait             = true
#   timeout          = 500
#   depends_on       = [helm_release.neo4j-headless]
#   # values           = ["${file("./charts/rabbitmq/rabbitmq.yaml")}"]

#   set {
#     name = "auth.username"
#     value = var.talentsphere-admin
#   }

#   set_sensitive {
#     name = "auth.password"
#     value = var.TALENTSPHERE_ADMIN_PASSWORD
#   }
# }



# resource "helm_release" "yugabyte" {
#   name             = "yugabyte"
#   repository       = "https://charts.yugabyte.com"
#   chart            = "yugabyte"
#   version          = "2.17.1"
#   namespace        = var.yugabyte-namespace
#   create_namespace = true
#   wait             = true
#   timeout          = 500
#   depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
#   values           = ["${file("./charts/yugabyte/yugabyte.yaml")}"]
# }



# resource "helm_release" "neo4j-headless" {
#   name             = "neo4j-headless"
#   repository       = "https://helm.neo4j.com/neo4j"
#   chart            = "neo4j-headless-service"
#   version          = "5.4.0"
#   namespace        = var.neo4j-namespace
#   create_namespace = true
#   wait             = true
#   depends_on       = [digitalocean_kubernetes_cluster.amplify-lafia]
#   timeout          = 500
#   values           = ["${file("./charts/neo4j/headless.yaml")}"]
# }

