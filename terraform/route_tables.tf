# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_default_route_table Default-Route-Table-for-redbullvcn {
  display_name  = "Default Route Table for redbullvcn"
  manage_default_resource_id = oci_core_vcn.redbullvcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.redbullig.id
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}