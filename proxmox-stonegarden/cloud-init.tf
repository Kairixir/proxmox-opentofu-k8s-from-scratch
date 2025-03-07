resource "proxmox_virtual_environment_file" "cloud-init-ctrl-01" {
  provider     = proxmox.medusa_proxmox
  node_name    = "medusa"
  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data = templatefile("./cloud-init/k8s-control-plane.yaml.tftpl", {
      common-config = templatefile("./cloud-init/k8s-common.yaml.tftpl", {
        hostname    = "k8s-ctrl-01"
        username    = "cantor"
        password    = "letmein"
        pub-key     = trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")
        k8s-version = "1.29"

        kubeadm-cmd = "kubeadm init --skip-phases=addon/kube-proxy"

      })
      username           = "cantor"
      cilium-cli-version = "0.16.4"

      cilium-cli-cmd = "HOME=/home/${var.vm_user} KUBECONFIG=/etc/kubernetes/admin.conf cilium install --set kubeProxyReplacement=true"

    })
    file_name = "cloud-init-k8s-ctrl-01.yaml"
  }
}

resource "proxmox_virtual_environment_file" "cloud-init-work-01" {
  provider     = proxmox.medusa_proxmox
  node_name    = "medusa"
  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data = templatefile("./cloud-init/k8s-control-plane.yaml.tftpl", {
      common-config = templatefile("./cloud-init/k8s-common.yaml.tftpl", {
        hostname    = "k8s-work-01"
        username    = "cantor"
        password    = "letmein"
        pub-key     = trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQWkgjI0SC99fxM0WPtjVgHH1K8r+s5sYdCLLavlfr Medusa Dell Wyse Legito Workstation")
        k8s-version = "1.29"

        kubeadm-cmd = module.kubeadm-join.stdout

      })

    })
    file_name = "cloud-init-k8s-work-01.yaml"
  }
}
