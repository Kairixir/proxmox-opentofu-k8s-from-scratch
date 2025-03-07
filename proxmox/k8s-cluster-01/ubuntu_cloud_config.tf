resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
  content_type = "snippets"
  datastore_id = "local-btrfs-vms"
  node_name    = "medusa"

  source_raw {
    data = <<EOF
#cloud-config
chpasswd:
  list: |
    ubuntu:ubuntu    
  expire: false
packages:
  - qemu-guest-agent
timezone: Europe/Prague

users:
  - default
  - name: ubuntu
    password: ${trimspace("letmein")}
    type: text
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")}
    sudo: ALL=(ALL) NOPASSWD:ALL

 power_state:
     delay: now
     mode: reboot
     message: Rebooting after cloud-init completion
     condition: true
EOF

    file_name = "ubuntu.cloud-config.yaml"
  }
}

