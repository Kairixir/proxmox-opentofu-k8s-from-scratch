# Generate inventory file
resource "local_file" "ansible_inventory" {
  filename = "/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox/kubespray/inventory/k8s-cluster-01/inventory.ini"
  content  = <<-EOF
  [all]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name} ansible_host=${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name} ansible_host=${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[0].name} ansible_host=${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[0].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[1].name} ansible_host=${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[1].ipv4_addresses[1][0]}

  [kube_control_plane]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name}

  [etcd]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[0].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl01[1].name}

  [kube_node]
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[0].name}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl01[1].name}

  [k8s_cluster:children]
  kube_node
  kube_control_plane

  EOF
}

resource "null_resource" "ansible_command" {
  provisioner "local-exec" {
    command     = "./kubespray.k8s-cluster-01.sh > k8s-cluster-01/ansible_output.log 2>&1"
    interpreter = ["/bin/bash", "-c"]
    working_dir = "/home/kairixir/code/personal/proxmox-opentofu-k8s-from-scratch/proxmox"
  }
  depends_on = [proxmox_virtual_environment_vm.k8s-cp-vms-cl01, proxmox_virtual_environment_vm.k8s-worker-vms-cl01, local_file.ansible_inventory]
}

