locals {

  # Merge changing vars to node
  computed_nodes = {
    for name, config in var.nodes : name => merge(config, {
      node_url       = var.external_access ? "localhost" : "kairixir.proxmox"
      node_api_token = var.proxmox_api_token
    })
  }
}

