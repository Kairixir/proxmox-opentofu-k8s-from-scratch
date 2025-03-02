#!/bin/bash

# Set working directory
WORKING_DIR="/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox"
cd "$WORKING_DIR" || exit

# Set virtual environment variables
VENVDIR="/home/kairixir/code/personal/kubespray-venv"
KUBESPRAYDIR="/home/kairixir/code/personal/kubespray"

# Activate virtual environment
source "$VENVDIR/bin/activate" || exit

# Change to Kubespray directory
cd "$KUBESPRAYDIR" || exit

# Run Ansible playbook
ansible-playbook -i inventory/k8s-cluster-01/inventory.ini --become --become-user=root cluster.yml -u ubuntu
