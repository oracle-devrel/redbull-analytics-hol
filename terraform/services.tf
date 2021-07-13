# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           Functions
#*************************************
# App
resource "oci_functions_application" "ods-application" {
  count = var.enable_functions ? 1 : 0
  
  compartment_id = var.compartment_ocid
  display_name = var.functions_app_name
  subnet_ids = [local.private_subnet_id]
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}