
resource "grafana_data_source" "prometheus" {
  name                = "prometheus"
  type                = "prometheus"
  url                 = var.prometheus_url
  is_default          = true

  json_data_encoded = jsonencode({
    httpMethod        = "POST"
    prometheusType    = "Prometheus"
    # tlsSkipVerify = true
  })

}

resource "grafana_data_source" "tempo" {
  name                = "tempo"
  type                = "tempo"
  url                 = var.tempo_url
  is_default          = false
}

resource "grafana_data_source" "jaeger" {
  name                = "jaeger"
  type                = "jaeger"
  url                 = var.jaeger_url
}

resource "grafana_data_source" "loki" {
  name                = "loki"
  type                = "loki"
  url                 = var.loki_url
}
