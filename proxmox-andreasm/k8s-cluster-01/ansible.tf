k8s-cluster-01/locals.tf-locals {
k8s-cluster-01/locals.tf-
k8s-cluster-01/locals.tf-  # Merge changing vars to node
k8s-cluster-01/locals.tf-  computed_nodes = {
k8s-cluster-01/locals.tf-    for name, config in var.nodes : name => merge(config, {
k8s-cluster-01/locals.tf-      node_url       = var.external_access ? "localhost" : "kairixir.proxmox"
k8s-cluster-01/locals.tf-      node_api_token = var.proxmox_api_token
k8s-cluster-01/locals.tf-    })
k8s-cluster-01/locals.tf-  }
k8s-cluster-01/locals.tf-}
k8s-cluster-01/locals.tf-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-#!/bin/bash
k8s-cluster-01/kubespray.k8s-cluster-01.sh-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-# Set working directory
k8s-cluster-01/kubespray.k8s-cluster-01.sh-WORKING_DIR="/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox"
k8s-cluster-01/kubespray.k8s-cluster-01.sh-cd "$WORKING_DIR" || exit
k8s-cluster-01/kubespray.k8s-cluster-01.sh-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-# Set virtual environment variables
k8s-cluster-01/kubespray.k8s-cluster-01.sh-VENVDIR="/home/kairixir/code/personal/kubespray-venv"
k8s-cluster-01/kubespray.k8s-cluster-01.sh-KUBESPRAYDIR="/home/kairixir/code/personal/kubespray"
k8s-cluster-01/kubespray.k8s-cluster-01.sh-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-# Activate virtual environment
k8s-cluster-01/kubespray.k8s-cluster-01.sh-source "$VENVDIR/bin/activate" || exit
k8s-cluster-01/kubespray.k8s-cluster-01.sh-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-# Change to Kubespray directory
k8s-cluster-01/kubespray.k8s-cluster-01.sh-cd "$KUBESPRAYDIR" || exit
k8s-cluster-01/kubespray.k8s-cluster-01.sh-
k8s-cluster-01/kubespray.k8s-cluster-01.sh-# Run Ansible playbook
k8s-cluster-01/kubespray.k8s-cluster-01.sh-ansible-playbook -i inventory/k8s-cluster-01/inventory.ini --become --become-user=root cluster.yml -u ubuntu
k8s-cluster-01/providers.tf-terraform {
k8s-cluster-01/providers.tf-  required_providers {
k8s-cluster-01/providers.tf-    proxmox = {
k8s-cluster-01/providers.tf-      source  = "bpg/proxmox"
k8s-cluster-01/providers.tf-      version = "0.73.0"
k8s-cluster-01/providers.tf-    }
k8s-cluster-01/providers.tf-  }
k8s-cluster-01/providers.tf-
k8s-cluster-01/providers.tf-  required_version = ">= 1.7.5"
k8s-cluster-01/providers.tf-}
k8s-cluster-01/providers.tf-
k8s-cluster-01/providers.tf-provider "proxmox" {
k8s-cluster-01/providers.tf-  endpoint  = "https://${local.computed_nodes["medusa"].node_url}:${local.computed_nodes["medusa"].node_proxmox_port}"
k8s-cluster-01/providers.tf-  api_token = local.computed_nodes["medusa"].node_api_token
k8s-cluster-01/providers.tf-
k8s-cluster-01/providers.tf-  insecure = true
k8s-cluster-01/providers.tf-  ssh {
k8s-cluster-01/providers.tf-    agent    = true
k8s-cluster-01/providers.tf-    username = local.computed_nodes["medusa"].node_ssh_user
k8s-cluster-01/providers.tf-
k8s-cluster-01/providers.tf-    dynamic "node" {
k8s-cluster-01/providers.tf-      for_each = [for n in local.computed_nodes : n if n.node_enabled]
k8s-cluster-01/providers.tf-      content {
k8s-cluster-01/providers.tf-        name    = node.value["node_name"]
k8s-cluster-01/providers.tf-        address = node.value["node_url"]
k8s-cluster-01/providers.tf-        port    = node.value["node_ssh_port"]
k8s-cluster-01/providers.tf-      }
k8s-cluster-01/providers.tf-    }
k8s-cluster-01/providers.tf-  }
k8s-cluster-01/providers.tf-}
k8s-cluster-01/terraform.tfvars-# if true route ssh and proxmox ports to localhost using ssh 
k8s-cluster-01/terraform.tfvars-external_access = true
k8s-cluster-01/terraform.tfvars-
k8s-cluster-01/terraform.tfvars-nodes = {
k8s-cluster-01/terraform.tfvars-  medusa = {
k8s-cluster-01/terraform.tfvars-    node_url          = null
k8s-cluster-01/terraform.tfvars-    node_api_token    = null
k8s-cluster-01/terraform.tfvars-    node_name         = "medusa"
k8s-cluster-01/terraform.tfvars-    node_enabled      = true
k8s-cluster-01/terraform.tfvars-    node_ssh_user     = "tofu"
k8s-cluster-01/terraform.tfvars-    node_ssh_port     = 22697
k8s-cluster-01/terraform.tfvars-    node_proxmox_port = 8006
k8s-cluster-01/terraform.tfvars-  }
k8s-cluster-01/terraform.tfvars-}
k8s-cluster-01/terraform.tfvars-
k8s-cluster-01/variables.tf-variable "nodes" {
k8s-cluster-01/variables.tf-  type = map(object({
k8s-cluster-01/variables.tf-    node_enabled      = bool
k8s-cluster-01/variables.tf-    node_name         = string
k8s-cluster-01/variables.tf-    node_url          = string
k8s-cluster-01/variables.tf-    node_ssh_user     = string
k8s-cluster-01/variables.tf-    node_ssh_port     = string
k8s-cluster-01/variables.tf-    node_proxmox_port = string
k8s-cluster-01/variables.tf-    node_api_token    = string
k8s-cluster-01/variables.tf-  }))
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-  default = {}
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-  description = "Map of nodes to be managed by Tofu"
k8s-cluster-01/variables.tf-}
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-variable "external_access" {
k8s-cluster-01/variables.tf-  type = bool
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-  default = false
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-  description = "Whether to route ssh and proxmox ports to localhost using ssh"
k8s-cluster-01/variables.tf-}
k8s-cluster-01/variables.tf-
k8s-cluster-01/variables.tf-variable "proxmox_api_token" {
k8s-cluster-01/variables.tf-  type        = string
k8s-cluster-01/variables.tf-  default     = null
k8s-cluster-01/variables.tf-  description = "API access token for Proxmox"
k8s-cluster-01/variables.tf-}
k8s-cluster-01/ubuntu_cloud_config.tf-resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
k8s-cluster-01/ubuntu_cloud_config.tf-  content_type = "snippets"
k8s-cluster-01/ubuntu_cloud_config.tf-  datastore_id = "local"
k8s-cluster-01/ubuntu_cloud_config.tf-  node_name    = "medusa"
k8s-cluster-01/ubuntu_cloud_config.tf-
k8s-cluster-01/ubuntu_cloud_config.tf-  source_raw {
k8s-cluster-01/ubuntu_cloud_config.tf-    data = <<EOF
k8s-cluster-01/ubuntu_cloud_config.tf-#cloud-config
k8s-cluster-01/ubuntu_cloud_config.tf-chpasswd:
k8s-cluster-01/ubuntu_cloud_config.tf-  list: |
k8s-cluster-01/ubuntu_cloud_config.tf-    ubuntu:ubuntu    
k8s-cluster-01/ubuntu_cloud_config.tf-  expire: false
k8s-cluster-01/ubuntu_cloud_config.tf-packages:
k8s-cluster-01/ubuntu_cloud_config.tf-  - qemu-guest-agent
k8s-cluster-01/ubuntu_cloud_config.tf-timezone: Europe/Prague
k8s-cluster-01/ubuntu_cloud_config.tf-
k8s-cluster-01/ubuntu_cloud_config.tf-users:
k8s-cluster-01/ubuntu_cloud_config.tf-  - default
k8s-cluster-01/ubuntu_cloud_config.tf-  - name: ubuntu
k8s-cluster-01/ubuntu_cloud_config.tf-    password: ${trimspace("letmein")}
k8s-cluster-01/ubuntu_cloud_config.tf-    type: text
k8s-cluster-01/ubuntu_cloud_config.tf-    groups: sudo
k8s-cluster-01/ubuntu_cloud_config.tf-    shell: /bin/bash
k8s-cluster-01/ubuntu_cloud_config.tf-    ssh-authorized-keys:
k8s-cluster-01/ubuntu_cloud_config.tf-      - ${trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")}
k8s-cluster-01/ubuntu_cloud_config.tf-    sudo: ALL=(ALL) NOPASSWD:ALL
k8s-cluster-01/ubuntu_cloud_config.tf-
k8s-cluster-01/ubuntu_cloud_config.tf- power_state:
k8s-cluster-01/ubuntu_cloud_config.tf-     delay: now
k8s-cluster-01/ubuntu_cloud_config.tf-     mode: reboot
k8s-cluster-01/ubuntu_cloud_config.tf-     message: Rebooting after cloud-init completion
k8s-cluster-01/ubuntu_cloud_config.tf-     condition: true
k8s-cluster-01/ubuntu_cloud_config.tf-EOF
k8s-cluster-01/ubuntu_cloud_config.tf-
k8s-cluster-01/ubuntu_cloud_config.tf-    file_name = "ubuntu.cloud-config.yaml"
k8s-cluster-01/ubuntu_cloud_config.tf-  }
k8s-cluster-01/ubuntu_cloud_config.tf-}
k8s-cluster-01/ubuntu_cloud_config.tf-
k8s-cluster-01/k8s-cluster-01.tf-resource "proxmox_virtual_environment_vm" "k8s-cp-vms-cl01" {
k8s-cluster-01/k8s-cluster-01.tf-  count       = 2
k8s-cluster-01/k8s-cluster-01.tf-  name        = "k8s-cp-vm-${count.index + 1}-cl-01"
k8s-cluster-01/k8s-cluster-01.tf-  description = "Managed by Tofu"
k8s-cluster-01/k8s-cluster-01.tf-  tags        = ["tofu", "ubuntu", "k8s-cp"]
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  node_name = "medusa"
k8s-cluster-01/k8s-cluster-01.tf-  vm_id     = "100${count.index + 1}"
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  cpu {
k8s-cluster-01/k8s-cluster-01.tf-    cores = 1
k8s-cluster-01/k8s-cluster-01.tf-    type  = "host"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  memory {
k8s-cluster-01/k8s-cluster-01.tf-    dedicated = 512
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  agent {
k8s-cluster-01/k8s-cluster-01.tf-    # read 'Qemu guest agent' section, change to true only when ready
k8s-cluster-01/k8s-cluster-01.tf-    enabled = false
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  startup {
k8s-cluster-01/k8s-cluster-01.tf-    order      = "3"
k8s-cluster-01/k8s-cluster-01.tf-    up_delay   = "60"
k8s-cluster-01/k8s-cluster-01.tf-    down_delay = "60"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  disk {
k8s-cluster-01/k8s-cluster-01.tf-    datastore_id = "local-btrfs-vms"
k8s-cluster-01/k8s-cluster-01.tf-    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
k8s-cluster-01/k8s-cluster-01.tf-    interface    = "virtio0"
k8s-cluster-01/k8s-cluster-01.tf-    iothread     = true
k8s-cluster-01/k8s-cluster-01.tf-    discard      = "on"
k8s-cluster-01/k8s-cluster-01.tf-    size         = 20
k8s-cluster-01/k8s-cluster-01.tf-    file_format  = "raw"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  initialization {
k8s-cluster-01/k8s-cluster-01.tf-    dns {
k8s-cluster-01/k8s-cluster-01.tf-      servers = ["10.100.1.7", "10.100.1.6"]
k8s-cluster-01/k8s-cluster-01.tf-      domain  = "my-domain.net"
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-    ip_config {
k8s-cluster-01/k8s-cluster-01.tf-      ipv4 {
k8s-cluster-01/k8s-cluster-01.tf-        address = "10.160.1.2${count.index + 1}/24"
k8s-cluster-01/k8s-cluster-01.tf-        gateway = "10.160.1.1"
k8s-cluster-01/k8s-cluster-01.tf-      }
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-    user_account {
k8s-cluster-01/k8s-cluster-01.tf-      username = "ubuntu"
k8s-cluster-01/k8s-cluster-01.tf-      password = trimspace("letmein")
k8s-cluster-01/k8s-cluster-01.tf-      keys     = [trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")]
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-    datastore_id = "local-btrfs-vms"
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-    # user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  network_device {
k8s-cluster-01/k8s-cluster-01.tf-    bridge  = "vmbr0"
k8s-cluster-01/k8s-cluster-01.tf-    vlan_id = "216"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  operating_system {
k8s-cluster-01/k8s-cluster-01.tf-    type = "l26"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  lifecycle {
k8s-cluster-01/k8s-cluster-01.tf-    ignore_changes = [
k8s-cluster-01/k8s-cluster-01.tf-      network_device
k8s-cluster-01/k8s-cluster-01.tf-    ]
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-}
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-resource "proxmox_virtual_environment_vm" "k8s-worker-vms-cl01" {
k8s-cluster-01/k8s-cluster-01.tf-  count       = 2
k8s-cluster-01/k8s-cluster-01.tf-  name        = "k8s-node-vm-${count.index + 1}-cl-01"
k8s-cluster-01/k8s-cluster-01.tf-  description = "Managed by Tofu"
k8s-cluster-01/k8s-cluster-01.tf-  tags        = ["tofu", "ubuntu", "k8s-node"]
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  node_name = "medusa"
k8s-cluster-01/k8s-cluster-01.tf-  vm_id     = "100${count.index + 5}"
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  cpu {
k8s-cluster-01/k8s-cluster-01.tf-    cores = 1
k8s-cluster-01/k8s-cluster-01.tf-    type  = "host"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  memory {
k8s-cluster-01/k8s-cluster-01.tf-    dedicated = 1024
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  agent {
k8s-cluster-01/k8s-cluster-01.tf-    # read 'Qemu guest agent' section, change to true only when ready
k8s-cluster-01/k8s-cluster-01.tf-    enabled = false
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  startup {
k8s-cluster-01/k8s-cluster-01.tf-    order      = "3"
k8s-cluster-01/k8s-cluster-01.tf-    up_delay   = "60"
k8s-cluster-01/k8s-cluster-01.tf-    down_delay = "60"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  disk {
k8s-cluster-01/k8s-cluster-01.tf-    datastore_id = "local-btrfs-vms"
k8s-cluster-01/k8s-cluster-01.tf-    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
k8s-cluster-01/k8s-cluster-01.tf-    interface    = "virtio0"
k8s-cluster-01/k8s-cluster-01.tf-    iothread     = true
k8s-cluster-01/k8s-cluster-01.tf-    discard      = "on"
k8s-cluster-01/k8s-cluster-01.tf-    size         = 60
k8s-cluster-01/k8s-cluster-01.tf-    file_format  = "raw"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  initialization {
k8s-cluster-01/k8s-cluster-01.tf-    dns {
k8s-cluster-01/k8s-cluster-01.tf-      servers = ["10.100.1.7", "10.100.1.6"]
k8s-cluster-01/k8s-cluster-01.tf-      domain  = "my-domain.net"
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-    ip_config {
k8s-cluster-01/k8s-cluster-01.tf-      ipv4 {
k8s-cluster-01/k8s-cluster-01.tf-        address = "10.160.1.2${count.index + 5}/24"
k8s-cluster-01/k8s-cluster-01.tf-        gateway = "10.160.1.1"
k8s-cluster-01/k8s-cluster-01.tf-      }
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-    user_account {
k8s-cluster-01/k8s-cluster-01.tf-      username = "ubuntu"
k8s-cluster-01/k8s-cluster-01.tf-      password = trimspace("letmein")
k8s-cluster-01/k8s-cluster-01.tf-      keys     = [trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")]
k8s-cluster-01/k8s-cluster-01.tf-    }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-    datastore_id = "local-btrfs-vms"
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-    # user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  network_device {
k8s-cluster-01/k8s-cluster-01.tf-    bridge  = "vmbr0"
k8s-cluster-01/k8s-cluster-01.tf-    vlan_id = "216"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  operating_system {
k8s-cluster-01/k8s-cluster-01.tf-    type = "l26"
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-  lifecycle {
k8s-cluster-01/k8s-cluster-01.tf-    ignore_changes = [
k8s-cluster-01/k8s-cluster-01.tf-      network_device
k8s-cluster-01/k8s-cluster-01.tf-    ]
k8s-cluster-01/k8s-cluster-01.tf-  }
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/k8s-cluster-01.tf-}
k8s-cluster-01/k8s-cluster-01.tf-
k8s-cluster-01/ansible.tf-# Generate inventory file
k8s-cluster-01/ansible.tf-resource "local_file" "ansible_inventory" {
k8s-cluster-01/ansible.tf:  filename = "/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox-andreasm/kubespray/inventory/k8s-cluster-01/inventory.ini"
k8s-cluster-01/ansible.tf-  content  = <<-EOF
k8s-cluster-01/ansible.tf-  [all]
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name} ansible_host=10.160.1.21
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name} ansible_host=10.160.1.22
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[0].name} ansible_host=10.160.1.25
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[1].name} ansible_host=10.160.1.26
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-  [kube_control_plane]
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name}
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name}
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-  [etcd]
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name}
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name}
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-  [kube_node]
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[0].name}
k8s-cluster-01/ansible.tf-  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[1].name}
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-  [k8s_cluster:children]
k8s-cluster-01/ansible.tf-  kube_node
k8s-cluster-01/ansible.tf-  kube_control_plane
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-  EOF
k8s-cluster-01/ansible.tf-}
k8s-cluster-01/ansible.tf-
k8s-cluster-01/ansible.tf-resource "null_resource" "ansible_command" {
k8s-cluster-01/ansible.tf-  provisioner "local-exec" {
k8s-cluster-01/ansible.tf-    command     = "./k8s-cluster-01/kubespray.k8s-cluster-01.sh > k8s-cluster-01/ansible_output.log 2>&1"
k8s-cluster-01/ansible.tf-    interpreter = ["/bin/bash", "-c"]
k8s-cluster-01/ansible.tf:    working_dir = "/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox-andreasm/"
k8s-cluster-01/ansible.tf-  }
k8s-cluster-01/ansible.tf-  depends_on = [proxmox_virtual_environment_vm.k8s-cp-vms-cl01, proxmox_virtual_environment_vm.k8s-worker-vms-cl01, local_file.ansible_inventory]
k8s-cluster-01/ansible.tf-}
k8s-cluster-01/ansible.tf-
proxmox-images/ubuntu_cloud_image.tf-resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
proxmox-images/ubuntu_cloud_image.tf-  content_type = "iso"
proxmox-images/ubuntu_cloud_image.tf-  datastore_id = "local"
proxmox-images/ubuntu_cloud_image.tf-  node_name    = "medusa"
proxmox-images/ubuntu_cloud_image.tf-
proxmox-images/ubuntu_cloud_image.tf-  source_file {
proxmox-images/ubuntu_cloud_image.tf-    # you may download this image locally on your workstation and then use the local path instead of the remote URL
proxmox-images/ubuntu_cloud_image.tf-    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
proxmox-images/ubuntu_cloud_image.tf-
proxmox-images/ubuntu_cloud_image.tf-    # you may also use the SHA256 checksum of the image to verify its integrity
proxmox-images/ubuntu_cloud_image.tf-    # checksum = "b9b65a7e045ca262ad614cbedeaa1bf34b9325d76f856e85e17b68984e7a4314"
proxmox-images/ubuntu_cloud_image.tf-  }
proxmox-images/ubuntu_cloud_image.tf-}
proxmox-images/providers.tf-terraform {
proxmox-images/providers.tf-  required_providers {
proxmox-images/providers.tf-    proxmox = {
proxmox-images/providers.tf-      source  = "bpg/proxmox"
proxmox-images/providers.tf-      version = "0.73.0"
proxmox-images/providers.tf-    }
proxmox-images/providers.tf-  }
proxmox-images/providers.tf-}
proxmox-images/providers.tf-
proxmox-images/providers.tf-provider "proxmox" {
proxmox-images/providers.tf-  endpoint  = var.proxmox_api_endpoint
proxmox-images/providers.tf-  api_token = var.proxmox_api_token
proxmox-images/providers.tf-  insecure  = true
proxmox-images/providers.tf-  ssh {
proxmox-images/providers.tf-    agent    = true
proxmox-images/providers.tf-    username = "kairixir"
proxmox-images/providers.tf-  }
proxmox-images/providers.tf-}
proxmox-images/variables.tf-variable "proxmox_api_endpoint" {
proxmox-images/variables.tf-  type        = string
proxmox-images/variables.tf-  default     = null
proxmox-images/variables.tf-  description = "Proxmox API endpoint URL"
proxmox-images/variables.tf-}
proxmox-images/variables.tf-
proxmox-images/variables.tf-variable "proxmox_api_token" {
proxmox-images/variables.tf-  type        = string
proxmox-images/variables.tf-  default     = null
proxmox-images/variables.tf-  description = "Proxmox API access token"
proxmox-images/variables.tf-}
