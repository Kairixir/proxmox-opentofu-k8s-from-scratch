resource "proxmox_virtual_environment_vm" "k8s-cp-vms-cl01" {
  count       = 2
  name        = "k8s-cp-vm-${count.index + 1}-cl-01"
  description = "Managed by Tofu"
  tags        = ["tofu", "ubuntu", "k8s-cp"]

  node_name = "medusa"
  vm_id     = "100${count.index + 1}"


  cpu {
    cores = 1
    type  = "host"
  }

  memory {
    dedicated = 512
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  disk {
    datastore_id = "local-btfs"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
    file_format  = "raw"
  }


  initialization {
    dns {
      servers = ["10.100.1.7", "10.100.1.6"]
      domain  = "my-domain.net"
    }
    ip_config {
      ipv4 {
        address = "10.160.1.2${count.index + 1}/24"
        gateway = "10.160.1.1"
      }
    }
    datastore_id = "local-btrfs-vms"

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = "216"
  }

  operating_system {
    type = "l26"
  }

  keyboard_layout = "no"

  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }


}

resource "proxmox_virtual_environment_vm" "k8s-worker-vms-cl01" {
  count       = 2
  name        = "k8s-node-vm-${count.index + 1}-cl-01"
  description = "Managed by Tofu"
  tags        = ["tofu", "ubuntu", "k8s-node"]

  node_name = "medusa"
  vm_id     = "100${count.index + 5}"


  cpu {
    cores = 1
    type  = "host"
  }

  memory {
    dedicated = 1024
  }


  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  disk {
    datastore_id = "local-btrfs"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 60
    file_format  = "raw"
  }


  initialization {
    dns {
      servers = ["10.100.1.7", "10.100.1.6"]
      domain  = "my-domain.net"
    }
    ip_config {
      ipv4 {
        address = "10.160.1.2${count.index + 5}/24"
        gateway = "10.160.1.1"
      }
    }
    datastore_id = "local-btrfs-vms"

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = "216"
  }

  operating_system {
    type = "l26"
  }

  keyboard_layout = "no"

  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }


}

