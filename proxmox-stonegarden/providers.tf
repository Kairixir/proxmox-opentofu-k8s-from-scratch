terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.0"
    }
  }

  required_version = ">= 1.7.5"
}

provider "proxmox" {
  alias     = "medusa_proxmox"
  endpoint  = "https://${local.computed_nodes["medusa"].node_url}:${local.computed_nodes["medusa"].node_proxmox_port}"
  api_token = local.computed_nodes["medusa"].node_api_token

  insecure = true
  ssh {
    agent    = true
    username = local.computed_nodes["medusa"].node_ssh_user

    dynamic "node" {
      for_each = [for n in local.computed_nodes : n if n.node_enabled]
      content {
        name    = node.value["node_name"]
        address = node.value["node_url"]
        port    = node.value["node_ssh_port"]
      }
    }
  }
}
