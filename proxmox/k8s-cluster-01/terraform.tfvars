# if true route ssh and proxmox ports to localhost using ssh 
external_access = true

nodes = {
  medusa = {
    node_url          = null
    node_api_token    = null
    node_name         = "medusa"
    node_enabled      = true
    node_ssh_user     = "tofu"
    node_ssh_port     = 22967
    node_proxmox_port = 8006
  }
}

