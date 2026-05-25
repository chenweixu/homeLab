
resource "kubernetes_namespace_v1" "csi-proxmox" {
  metadata {
    name = "csi-proxmox"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "baseline"
      "pod-security.kubernetes.io/warn"    = "baseline"
    }
  }
}


resource "kubernetes_secret_v1" "proxmox-csi-plugin" {
  metadata {
    name      = "proxmox-csi-plugin"
    namespace = kubernetes_namespace_v1.csi-proxmox.id
  }

  data = {
    "config.yaml" = <<EOF
clusters:
- url: "${var.proxmox_endpoint}/api2/json"
  insecure: true
  token_id: "${proxmox_user_token.kubernetes-csi-token.id}"
  token_secret: "${element(split("=", proxmox_user_token.kubernetes-csi-token.value), length(split("=", proxmox_user_token.kubernetes-csi-token.value)) - 1)}"
  region: ${var.proxmox_cluster_name}
EOF
  }
}
