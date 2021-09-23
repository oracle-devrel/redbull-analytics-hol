# Copyright (c) 2021 Oracle and/or its affiliates.

locals {
  private_key = try(file(var.private_key_path), var.private_key)
  ssh_public_key = try(file(var.ssh_public_key_path), var.ssh_public_key)
  
  ssh_public_keys = join("\n", [
    trimspace(local.ssh_public_key),
    trimspace(tls_private_key.this.public_key_openssh)
  ])
  
  release = "1.0"
  
  #Transform the list of images in a tuple
  list_images = { for s in data.oci_core_images.this.images :
    s.display_name =>
    { id = s.id,
      operating_system = s.operating_system
    }
  }
  
}