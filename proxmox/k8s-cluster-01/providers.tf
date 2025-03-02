terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
  ssh {
    agent    = true
    username = var.proxmox_ssh_user

    node {
      name    = "medusa"
      address = "192.168.2.110"
      port    = var.leader_node_port
    }
  }
}
