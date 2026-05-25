
# 组件模板
resource "elasticstack_elasticsearch_component_template" "my_component_template" {
  name = "my_component_template"

  template {
    alias {
      name = "my_template_test"
    }

    settings = jsonencode({
      number_of_shards = "3",
      index = {
        lifecycle = {
          name = elasticstack_elasticsearch_index_lifecycle.my_ilm.name
        }
      }
    })
  }
}

resource "elasticstack_elasticsearch_index_template" "my_index_template" {
  name = "my_index_template"

  index_patterns = ["a-stream*"]
  composed_of    = [elasticstack_elasticsearch_component_template.my_component_template.name]
}
