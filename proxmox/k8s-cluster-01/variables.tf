variable "proxmox_api_endpoint" {
  type        = string
  default     = null
  description = "Proxmox API endpoint URL"
}

variable "proxmox_api_token" {
  type        = string
  default     = null
  description = "Proxmox API access token"
}

variable "leader_node_port" {
  type        = string
  default     = null
  description = "Port for the leader node machine"
}

variable "proxmox_ssh_user" {
  type        = string
  default     = "tofu"
  description = "Default user to control proxmox host with"
}
