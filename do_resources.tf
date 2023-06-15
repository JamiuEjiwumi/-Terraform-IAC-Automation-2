data "digitalocean_kubernetes_versions" "amplify-lafia" {
  version_prefix = "1.25."
}



resource "digitalocean_kubernetes_cluster" "amplify-lafia" {
  name   = var.cluster-name
  region = "nyc3"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = data.digitalocean_kubernetes_versions.amplify-lafia.latest_version

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = var.cluster-name
    size       = "s-4vcpu-8gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 2

  }
}
 


resource "digitalocean_spaces_bucket" "amplify-lafia" {
  name   = var.cluster-name
  region = "nyc3"
}



# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "airflow" {
  domain = var.dns-name
  type   = "A"
  name   = "airflow"
  value  = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "postgresql" {
  domain = var.dns-name
  type   = "A"
  name   = "postgresql"
  value = data.digitalocean_droplet.amplify-lafia.ipv4_address
}



resource "digitalocean_record" "keycloak" {
  domain = var.dns-name
  type   = "A"
  name   = "keycloak"
  value = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "neo4j" {
  domain = var.dns-name
  type   = "A"
  name   = "neo4j"
  value  = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "neo4j-database" {
  domain = var.dns-name
  type   = "A"
  name   = "neo4j-database"
  value  = data.kubernetes_service.neo4j.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "lakefs" {
  domain = var.dns-name
  type   = "A"
  name   = "lakefs"
  value = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "superset" {
  domain = var.dns-name
  type   = "A"
  name   = "superset"
  value = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}



resource "digitalocean_record" "spark" {
  domain = var.dns-name
  type   = "A"
  name   = "spark"
  value = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
}