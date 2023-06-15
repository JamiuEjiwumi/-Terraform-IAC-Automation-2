resource "kubectl_manifest" "issuer" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    # Remember to update this if you use this manifest to obtain real certificates :)
    email: m.akomolafe@parallelscore.com
    # server: https://acme-staging-v02.api.letsencrypt.org/directory
    # To use the production environment, use the following line instead:
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: issuer-letsencrypt-production
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
depends_on = [ kubernetes_ingress_v1.keycloak ]
}



resource "kubectl_manifest" "certificate" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: amplify-lafia-cert
spec:
  secretName: amplify-lafia-cert-secret
  dnsNames:
  - spark.${var.dns-name} 
  - neo4j.${var.dns-name}
  - lakefs.${var.dns-name}
  - airflow.${var.dns-name}
  - superset.${var.dns-name}
  - keycloak.${var.dns-name}
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
YAML
depends_on = [ kubectl_manifest.issuer ]
}