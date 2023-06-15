variable "ingress-namespace" {
  description = "Namespace name for ingress deployment"
  type        = string
  default     = "ingress-nginx"
}


variable "postgres-namespace" {
  description = "Namespace name for Postgresql deployment"
  type        = string
  default     = "postgres"
}

variable "postgres-service-name" {
  description = "Name of the postgres service"
  type        = string
  default     = "postgres-postgresql"
}


variable "yugabyte-namespace" {
  description = "Namespace name for yugabyte deployment"
  type        = string
  default     = "yugabyte"
}


variable "lakefs-namespace" {
  description = "Namespace name for LakeFS deployment"
  type        = string
  default     = "lakefs"
}

variable "lakefs-service-name" {
  description = "Name of the lakefs service"
  type        = string
  default     = "lakefs"
}


variable "airflow-namespace" {
  description = "Namespace name for Apache Airflow deployment"
  type        = string
  default     = "airflow"
}

variable "airflow-service-name" {
  description = "Name of the airflow service"
  type        = string
  default     = "airflow-webserver"
}


variable "amplify-lafia-admin" {
  description = "Amplify Lafia Admin username"
  type        = string
  default     = "amplify-lafia-admin"
}

variable "admin-first-name" {
  description = "Admin's First Name"
  type        = string
  default     = "Amplify"
}

variable "admin-last-name" {
  description = "Admin's Last Name"
  type        = string
  default     = "Lafia"
}

variable "admin-email" {
  description = "Email ID for the Admin"
  type        = string
  default     = "m.akomolafe@parallelscore.com"
}


variable "superset-namespace" {
  description = "Namespace name for Apache Superset deployment"
  type        = string
  default     = "superset"
}

variable "superset-service-name" {
  description = "Name of the Apache Superset service"
  type        = string
  default     = "superset"
}


variable "neo4j-namespace" {
  description = "Namespace name for Neo4j deployment"
  type        = string
  default     = "neo4j"
}

variable "neo4j-service-name" {
  description = "Name of the neo4j service"
  type        = string
  default     = "neo4j-lb-neo4j"
}


variable "spark-namespace" {
  description = "Namespace name for spark-cluster deployment"
  type        = string
  default     = "spark"
}

variable "spark-service-name" {
  description = "Name of the spark service"
  type        = string
  default     = "spark-master-svc"
}


variable "rabbitmq-namespace" {
  description = "Namespace name for rabbitmq deployment"
  type        = string
  default     = "rabbitmq"
}



variable "cert-manager-namespace" {
  description = "Namespace for the cert-manager"
  type        = string
  default     = "cert-manager"
}


variable "keycloak-namespace" {
  description = "Namespace name for keycloak deployment"
  type        = string
  default     = "keycloak"
}



variable "keycloak-service-name" {
  description = "Names of the keycloak service"
  type        = string
  default     = "keycloak"
}