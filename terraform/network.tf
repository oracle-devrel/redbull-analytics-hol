# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#               VCN
#*************************************

resource "oci_core_vcn" "ods-vcn" {
  count          = var.ods_vcn_use_existing ? 0 : 1
  cidr_block     = var.ods_vcn_cidr
  compartment_id = var.compartment_ocid
  dns_label      = "ods"
  display_name   = var.ods_vcn_name
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

#*************************************
#           Subnet
#*************************************

resource "oci_core_subnet" "ods-private-subnet" {
  count = var.ods_vcn_use_existing ? 0 : 1
  
  cidr_block     = var.ods_subnet_private_cidr
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ods-vcn[0].id
  display_name   = var.ods_subnet_private_name

  # Private Subnet
  prohibit_public_ip_on_vnic = true
  dns_label                  = "odsprivate"
  route_table_id             = oci_core_route_table.ods-private-rt[0].id
  security_list_ids          = [oci_core_security_list.ods-private-sl[0].id]
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}


#*************************************
#         NAT Gateway
#*************************************

resource "oci_core_nat_gateway" "ods-nat-gateway" {
  count = var.ods_vcn_use_existing ? 0 : 1
  
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ods-vcn[0].id
  display_name = "Data Science NAT Gateway"
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}


#*************************************
#           Route Tables
#*************************************

resource "oci_core_route_table" "ods-private-rt" {
  count = var.ods_vcn_use_existing ? 0 : 1
  
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ods-vcn[0].id
  display_name   = "Data Science Private RT"

  # NAT Gateway
  route_rules {
    network_entity_id = oci_core_nat_gateway.ods-nat-gateway[0].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

#*************************************
#         Security List
#*************************************

resource "oci_core_security_list" "ods-private-sl" {
  count          = var.ods_vcn_use_existing ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ods-vcn[0].id
  display_name   = "Data Science Private SL"

  # Egress - Allow All
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "All"
    stateless        = false
    destination_type = "CIDR_BLOCK"
  }
  # Ingress - Allow VCN
  ingress_security_rules {
    protocol    = "All"
    source      = var.ods_vcn_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}
