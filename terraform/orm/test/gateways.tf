# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_internet_gateway redbullig {
  compartment_id = oci_identity_compartment.redbullhol.id
  display_name  = "redbullig"
  enabled       = "true"
  vcn_id = oci_core_vcn.redbullvcn.id
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}
