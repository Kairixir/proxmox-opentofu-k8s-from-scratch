resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "medusa"

  source_file {
    # you may download this image locally on your workstation and then use the local path instead of the remote URL
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

    # you may also use the SHA256 checksum of the image to verify its integrity
    # checksum = "b9b65a7e045ca262ad614cbedeaa1bf34b9325d76f856e85e17b68984e7a4314"
  }
}
