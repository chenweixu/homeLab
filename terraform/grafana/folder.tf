
resource "grafana_folder" "tmp" {
  title = "tmp"
}

resource "grafana_folder" "k8s" {
  title = "k8s"
}

resource "grafana_folder" "host" {
  title = "host"
}
