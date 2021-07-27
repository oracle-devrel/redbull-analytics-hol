# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

resource "random_id" "groups" {
  byte_length = 2
}

#*************************************
#           Groups
#*************************************

resource "oci_identity_group" "ods-group" {
  count          = var.create_ods_group == true ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "Data Science Group"
  name           = local.ods_group_name
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

#*************************************
#          Dynamic Groups
#*************************************

resource "oci_identity_dynamic_group" "ods-dynamic-group" {
  provider = oci.home
  compartment_id = var.tenancy_ocid
  description = "Data Science Dynamic Group"
  name = local.ods_dynamic_group_name
  matching_rule = "any {all {resource.type='fnfunc',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='ApiGateway',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='datasciencenotebooksession',resource.compartment.id='${var.compartment_ocid}'} }"
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

#*************************************
#           Policies
#*************************************

resource "oci_identity_policy" "ods-policy" {
  provider       = oci.home
  compartment_id = var.compartment_ocid
  description    = "Data Science Policies"
  name           = var.ods_policy_name
  depends_on = [
    oci_identity_group.ods-group,
    oci_identity_dynamic_group.ods-dynamic-group,
    oci_identity_tag_namespace.devrel
  ]
  
  statements = [
    "Allow group ${local.ods_group_name} to manage data-science-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}"}",
    "Allow group ${local.ods_group_name} to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}"}",
    "Allow group ${local.ods_group_name} to manage functions-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow service datascience to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}"}",
    "Allow service FaaS to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${local.ods_dynamic_group_name} to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${local.ods_dynamic_group_name} to use functions-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${local.ods_dynamic_group_name} to manage data-science-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${local.ods_dynamic_group_name} to manage objects ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${local.ods_dynamic_group_name} to manage dataflow-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow service FaaS to read repos ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}"}",
    "Allow group ${local.ods_group_name} to manage repos ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}"}",
  ]
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}
