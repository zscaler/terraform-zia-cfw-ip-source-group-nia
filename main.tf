resource "zia_firewall_filtering_ip_source_groups" "this" {
  for_each     = local.consul_services
  name         = replace("${var.src_ip_group_prefix}${each.key}", "/[^0-9A-Za-z]/", "-")
  description  = "Dynamic source ip group generated for service registered in Consul"
  ip_addresses = [for s in each.value : s.address]
}
locals {
  consul_services = {
    for id, s in var.services : s.name => s...
  }
}

resource "null_resource" "activation" {

  triggers = {
    version = local.timestamp
  }
  provisioner "local-exec" {
    command     = "${path.module}/ziaActivator.sh"
    interpreter = ["/bin/sh"]
  }
}



locals {
  timestamp = timestamp()
}
