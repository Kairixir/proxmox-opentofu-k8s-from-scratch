variable "nodes" {
  type = map(object({
    node_enabled      = bool
    node_name         = string
    node_url          = string
    node_ssh_user     = string
    node_ssh_port     = string
    node_proxmox_port = string
    node_api_token    = string
  }))

  default = {}

  description = "Map of nodes to be managed by Tofu"
}

variable "external_access" {
  type = bool

  default = false

  description = "Whether to route ssh and proxmox ports to localhost using ssh"
}

variable "proxmox_api_token" {
  type        = string
  default     = null
  description = "API access token for Proxmox"
}
