
resource "kubernetes_secret_v1" "sealed-secrets-key" {
  type = "kubernetes.io/tls"
  metadata {
    name      = "sealed-secrets-bootstrap-key"
    namespace = "kube-system"
    labels = {
      "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }

  data = {
    "tls.crt" = file(var.sealed_secrets_config.certificate_path)
    "tls.key" = file(var.sealed_secrets_config.certificate_key_path)
  }
}
