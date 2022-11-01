# Global Config Options
log_level = "INFO"
port = 8558
working_dir = "sync-tasks"

syslog {
  enabled = false
}

buffer_period {
  enabled = true
  min = "5s"
  max = "20s"
}

# Vault Config Options
# vault {}

# Consul Config Options
consul {
  address = "10.0.31.151:8500"
}

# Terraform Driver Options
driver "terraform" {
  log = true
  persist_log = false
  required_providers {
    zia = {
      source = "zscaler/zia"
    }
  }
}

# Zscaler Internet Access Workflow Options
# terraform_provider "zia" {
#   username = "{{ with secret \"zscaler/ziacloud\" }}{{ .Data.data.username }}{{ end }}"
#   password = "{{ with secret \"zscaler/ziacloud\" }}{{ .Data.data.password }}{{ end }}"
#   api_key  = "{{ with secret \"zscaler/ziacloud\" }}{{ .Data.data.api_key }}{{ end }}"
#   zia_cloud = "{{ with secret \"zscaler/ziacloud\" }}{{ .Data.data.zia_cloud }}{{ end }}"
# }

terraform_provider "zpa" {
  username  = ""
  password  = ""
  api_key   = ""
  zia_cloud = ""
}

task {
  name = "zia_cfw_source_ip_group"
  description = "Create Source IP Group"
  enabled = true,
  module = "./"
  variable_files = []
  providers = ["zia"]
  condition "services" {
    names = ["nginx", "web", "api"]

 }
}
