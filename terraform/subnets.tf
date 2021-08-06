# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_subnet redbullsubnet {
  cidr_block     = "192.168.1.0/24"
  compartment_id = oci_identity_compartment.redbullhol.id
  
  dhcp_options_id = oci_core_vcn.redbullvcn.default_dhcp_options_id
  display_name    = "redbullsubnet"
  dns_label       = "redbullsubnet"
  
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_vcn.redbullvcn.default_route_table_id
  
  security_list_ids = [
    oci_core_vcn.redbullvcn.default_security_list_id,
  ]
  
  vcn_id = oci_core_vcn.redbullvcn.id
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}
