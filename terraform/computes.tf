# Copyright (c) 2021 Oracle and/or its affiliates.

### custom image

resource "oci_core_image" "redbullhol_image" {
  compartment_id = oci_identity_compartment.redbullhol.id
  depends_on = [time_sleep.wait_60_seconds]
  
  display_name = "redbullhol_image"
  
  image_source_details {
    source_type = "objectStorageUri"
    source_uri = "https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/z5YCJTj_N5yMUIfygE6Xx39R5jkoothfDchyfONffyy2v-jVqXlUYI88VG5v8Akn/n/emeasespainsandbox/b/publichol/o/redbullhol-20210805-1051"
  }
}

#### redbull_lab1
resource oci_core_instance redbull_lab1 {
  availability_domain = data.oci_identity_availability_domain.AD1.name
  compartment_id      = oci_identity_compartment.redbullhol.id
  shape               = "VM.Standard2.2"
  
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
    "ssh_authorized_keys" = var.ssh_public_key
  }

  source_details {
    source_id = oci_core_image.redbullhol_image.id    
    source_type = "image"
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}