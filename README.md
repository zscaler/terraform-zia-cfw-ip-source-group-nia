<a href="https://terraform.io">
    <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-text.svg" alt="Terraform logo" title="Terraform" height="50" width="250" />
</a>
<a href="https://www.zscaler.com/">
    <img src="https://www.zscaler.com/themes/custom/zscaler/logo.svg" alt="Zscaler logo" title="Zscaler" height="50" width="250" />
</a>

Zscaler Internet Access (ZIA) Cloud Firewall IP Source Group Module for Network Infrastructure Automation
===========================================================================================================

This Terraform module allows users to support **IP Source Groups** by integrating [Consul Terraform Sync](https://www.consul.io/docs/nia) with Zscaler Internet Access [ZIA Cloud](https://help.zscaler.com/zia/configuring-source-ip-groups) to dynamically manage the **ip_addresses**, list based on service definition in Consul Catalog.

Using this Terraform module in conjunction with **consul-terraform-sync** enables teams to reduce manual ticketing processes and automate Day-2 operations related to application scale up/down in a way that is both declarative and repeatable across the organization and across multiple **IP Source Groups**.

#### Note: This Terraform module is designed to be used only with **consul-terraform-sync**

## Feature

This module supports the following:

* Create, update and delete IP Source Group entries based on the services in Consul catalog.

If there is a missing feature or a bug - [open an issue](https://github.com/zscaler/terraform-zia-cfw-ip-source-group/issues)

## What is consul-terraform-sync?

The **consul-terraform-sync** runs as a daemon that enables a **publisher-subscriber** paradigm between **Consul** and **ZIA Cloud** to support **Network Infrastructure Automation (NIA)**.

<p align="left">
<img width="800" src="https://github.com/zscaler/terraform-zia-cfw-ip-source-group-nia/blob/master/images/consul-terraform-sync-arch.png"> </a>
</p>

* consul-terraform-sync **subscribes to updates from the Consul catalog** and executes one or more automation **"tasks"** with appropriate value of *service variables* based on those updates. **consul-terraform-sync** leverages [Terraform](https://www.terraform.io/) as the underlying automation tool and utilizes the Terraform provider ecosystem to drive relevant change to the network infrastructure.

* Each task consists of a runbook automation written as a compatible **Terraform module** using resources and data sources for the underlying network infrastructure provider.

Please refer to this [link](https://www.consul.io/docs/nia/installation/install) for getting started with **consul-terraform-sync**

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.2.0 |
| <a name="requirement_zia"></a> [zia](#requirement\_zia) | >=2.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >=3.2.0 |
| <a name="provider_zia"></a> [zia](#provider\_zia) | >=2.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.activation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [zia_firewall_filtering_ip_source_groups.this](https://registry.terraform.io/providers/zscaler/zia/latest/docs/resources/firewall_filtering_ip_source_groups) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_services"></a> [services](#input\_services) | Consul services monitored by Consul-Terraform-Sync | <pre>map(<br>    object({<br>      id        = string<br>      name      = string<br>      kind      = string<br>      address   = string<br>      port      = number<br>      meta      = map(string)<br>      tags      = list(string)<br>      namespace = string<br>      status    = string<br><br>      node                  = string<br>      node_id               = string<br>      node_address          = string<br>      node_datacenter       = string<br>      node_tagged_addresses = map(string)<br>      node_meta             = map(string)<br><br>      cts_user_defined_meta = map(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_src_ip_group_prefix"></a> [src\_ip\_group\_prefix](#input\_src\_ip\_group\_prefix) | (Optional) Prefix added to dynamic objects | `string` | `"consul-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_null_resource_activation"></a> [null\_resource\_activation](#output\_null\_resource\_activation) | Null resource output from activation script |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Compatibility

This module is meant for use with **consul-terraform-sync >= 0.1.0** and **Terraform >= 0.13**.

## Usage

In order to use this module, you will need to install **consul-terraform-sync**, create a **"task"** with this Terraform module as a source within the task, and run **consul-terraform-sync**.

The users can subscribe to the services in the consul catalog and define the Terraform module which will be executed when there are any updates to the subscribed services using a **"task"**.

**~> Note:** It is recommended to have the [consul-terraform-sync config guide](https://www.consul.io/docs/nia/installation/configuration) for reference.

1. Download the **consul-terraform-sync** on a node which is highly available (preferably, a node running a consul client)
2. Add **consul-terraform-sync** to the PATH on that node
3. Check the installation

  ```
  $ consul-terraform-sync --version
  0.1.0
  Compatible with Terraform ~>0.13.0
  ```

4. Create a config file **"tasks.hcl"** for consul-terraform-sync. Please note that this just an example.

```
terraform
log_level = "info"

consul {
    address = "192.168.0.1:8500"
}

buffer_period {
    min = "5s"
    max = "20s"
}

driver "terraform" {
  log = true
  required_providers {
    zia = {
      source = "zscaler/zia"
    }
  }
}

terraform_provider "zia" {
  username  = ""
  password  = ""
  api_key   = ""
  zia_cloud = ""
}

<!-- task {
  name = "Create_Source_IP_Group_ZIA_CFW"
  description = "Zscaler Internet Access Cloud Firewall Source IP Group based on service definition"
  enabled = true,
  module = "./"
  variable_files = []
  providers = ["zia"]
  condition "services" {
    names = ["web", "api"]
 }
} <!--

task {
  name = <name of the task (has to be unique)> # eg. "Create_Source_IP_Group_ZIA_CFW"
  description = <description of the task> # eg. "Zscaler Internet Access Cloud Firewall Source IP Group based on service definition"
  source = "sample_dir/zscaler"
  providers = ["zia"]
  services = ["<list of consul services you want to subscribe to>"] # eg. ["web", "api"]
  variable_files = ["<list of files that have user variables for this module (please input full path)>"] # eg. ["/sample_dir/checkpoint/sample.tfvars"]
}
```

5. Start consul-terraform-sync

```
consul-terraform-sync -config-file=sample.hcl
```

**consul-terraform-sync** will create Dynamic Objects on Check Point devices based on the values in consul catalog.

**consul-terraform-sync is now subscribed to the Consul catalog. Any updates to the services identified in the task will result in updating the address and Dynamic Objects on the Check Point devices**

### 3. Configure consul-terraform-sync

1. Donwload and transfer the following files to the server where you will be running consul-terraform-sync. Please refer to this [link](https://releases.hashicorp.com/consul-terraform-sync/) to download latest version of consul-terraform-sync.

Files: consul-terraform-sync (binary), main.tf, variables.tf, publish.sh, publish_linux or publish_osx

2. Modify sample.hcl

**Consul Server**

```
consul {
    address = "192.168.0.1:8500"
}
```

**Tasks** - Update Consul services you want to monitor

```
task {
  name = "Create_Source_IP_Group_ZIA_CFW"
  description = "Zscaler Internet Access Cloud Firewall Source IP Group based on service definition"
  enabled = true,
  module = "./"
  variable_files = []
  providers = ["zia"]
  condition "services" {
    names = ["web", "api"]
 }
}
```

  Note: If you did not specify a -config-dir then you can use **module = "../../"**

**Provider** - Use Check Point credentials from previous steps

```
terraform_provider "zia" {
  username  = ""
  password  = ""
  api_key   = ""
  zia_cloud = ""
}
```

  Note: You can also use **api-key** by replacing username/password

3. Update activation.sh

Use ZIA credentials from previous steps.

!> **WARNING:** Hard-coding credentials into any Terraform configuration or shell scripts is not recommended, and risks secret leakage should this file be committed to public version control

```
#!/bin/bash
sleep 2
if [[ "$OSTYPE" == "linux"* ]]; then
ziaActivator_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
ziaActivator_osx
fi
```

Note: The **Activator** binary is for Linux 64bit and OSX. For all other platforms, please follow [this link](https://registry.terraform.io/providers/zscaler/zia/latest/docs/guides/zia-activator-overview) to complile the required platform.

4. Start the consul-terraform-sync

```
chmod 755 consul-terraform-sync
./consul-terraform-sync --config-file sample.hcl
```

 5. Start consul-terraform-sync

```
consul-terraform-sync -config-file=tasks.hcl
```

**consul-terraform-sync** will create right set of IP Source Groups in the ZIA Cloud based on the values in consul catalog.

**consul-terraform-sync is now subscribed to the Consul catalog. Any updates to the services identified in the task will result in updating the application segment in the ZIA Cloud**

# License and Copyright

Copyright (c) 2022 Zscaler, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
