# Copyright (c) 2021 Oracle and/or its affiliates.

#### redbull_lab1
resource oci_core_instance redbull_lab1 {
  availability_domain = data.oci_identity_availability_domain.AD1.name
  compartment_id      = oci_identity_compartment.redbullhol.id
  shape = "VM.Standard2.2"
  
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
  }
  
  create_vnic_details {
    assign_public_ip = "true"
    display_name  = "redbulllab1"
    hostname_label = "redbulllab1"
    private_ip             = "192.168.1.3"
    skip_source_dest_check = "false"
    subnet_id              = oci_core_subnet.redbullsubnet.id
  }
  
  display_name      = "redbulllab1"
  
  metadata = {
    ssh_authorized_keys = local.ssh_public_keys
  }
  
  source_details {
    source_id = local.list_images[var.compute_image_name].id
    source_type = "image"
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
  
    connection {
    agent       = false
    timeout     = "60m"
    host        = oci_core_instance.redbull_lab1.public_ip
    user        = "opc"
    private_key = tls_private_key.public_private_key_pair.private_key_pem
  }

  provisioner "file" {
    source      = "scripts/jupyterlab.service"
    destination = "/home/opc/jupyterlab.service"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/launchapp.sh"
    destination = "/home/opc/launchapp.sh"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/launchjupyterlab.sh"
    destination = "/home/opc/launchjupyterlab.sh"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/script_install_pyenv.sh"
    destination = "/home/opc/script_install_pyenv.sh"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/script_install_root.sh"
    destination = "/home/opc/script_install_root.sh"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "file" {
    source      = "scripts/checkpyenv.py"
    destination = "/home/opc/checkpyenv.py"
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/opc/script_install_pyenv.sh",
      "chmod +x /home/opc/script_install_root.sh",
      "chmod +x /home/opc/launchjupyterlab.sh",
      "chmod +x /home/opc/launchapp.sh",
      "/home/opc/script_install_pyenv.sh",
      "sudo -i /home/opc/script_install_root.sh"
    ]
    
    connection {
      private_key = tls_private_key.this.private_key_pem
      user = "opc"
      host = self.public_ip
    }
  }
}