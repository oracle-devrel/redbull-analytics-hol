# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_vcn redbullvcn {
  cidr_block     = "192.168.1.0/24"
  compartment_id = oci_identity_compartment.redbullhol.id
  depends_on = [time_sleep.wait_60_seconds]

  display_name  = "redbullvcn"
  dns_label     = "redbullvcn"
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }

}
