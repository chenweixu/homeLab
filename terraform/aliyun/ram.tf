
resource "alicloud_ram_user" "oss" {
  name         = "oss"
  display_name = "oss"
  force        = false # true 时销毁用户
  timeouts {}
}
#===================================================================

resource "alicloud_ram_user" "cert_manager" {
  name         = var.cert_ram_user_name
  display_name = "cert_manager"
  force        = false
}

# 创建 AccessKey(API 调用凭证)
resource "alicloud_ram_access_key" "cert_manager" {
  user_name = alicloud_ram_user.cert_manager.name
}

output "cert_manager_ram_user_name" {
  value = alicloud_ram_user.cert_manager.name
}


output "cert_manager_access_key_id" {
  value     = alicloud_ram_access_key.cert_manager.id
  sensitive = true
}

output "cert_manager_access_key_secret" {
  value     = alicloud_ram_access_key.cert_manager.secret
  sensitive = true
}

#===================================================================

resource "alicloud_ram_policy" "tf_cert_manager" {
  policy_name = "tf-cert-manager"
  description = "tf-dns-cert-manager"

  policy_document = jsonencode({
    Statement = [
      {
        Action = [
          "alidns:AddDomain",
          "alidns:AddDomainRecord",
          "alidns:DescribeDomains",
          "alidns:DescribeDomainRecords",
          "alidns:UpdateDomainRecord",
          "alidns:DeleteDomainRecord"
        ]
        Effect = "Allow"
        Resource = [
          "acs:alidns:*:*:domain/*"
        ]
      }
    ]
    Version = "1"
  })

}


# 直接将权限附加给用户
resource "alicloud_ram_user_policy_attachment" "cert" {
  policy_name = alicloud_ram_policy.tf_cert_manager.policy_name
  policy_type = alicloud_ram_policy.tf_cert_manager.type
  user_name   = alicloud_ram_user.cert_manager.name
}


output "tf_cert_manager_policy_name" {
  value = alicloud_ram_policy.tf_cert_manager.policy_name
}


#===================================================================
