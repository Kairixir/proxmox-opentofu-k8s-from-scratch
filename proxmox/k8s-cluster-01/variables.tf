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
