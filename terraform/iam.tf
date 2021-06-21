# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           Groups
#*************************************

resource "oci_identity_group" "ods-group" {
  provider = oci.home
  compartment_id = var.tenancy_ocid
  description = "Data Science Group"
  name = var.ods_group_name
}

#*************************************
#          Dynamic Groups
#*************************************

resource "oci_identity_dynamic_group" "ods-dynamic-group" {
  provider = oci.home
  compartment_id = var.tenancy_ocid
  description = "Data Science Dynamic Group"
  name = var.ods_dynamic_group_name
  matching_rule = "any {all {resource.type='fnfunc',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='ApiGateway',resource.compartment.id='${var.compartment_ocid}'}, all {resource.type='datasciencenotebooksession',resource.compartment.id='${var.compartment_ocid}'} }"
}

#*************************************
#           Policies
#*************************************
locals {
  vault_policies = [
    "Allow group ${oci_identity_group.ods-group.name} to manage vaults ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }",
    "Allow group ${oci_identity_group.ods-group.name} to manage keys ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }",
    "Allow group ${oci_identity_group.ods-group.name} to manage secret-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }",
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage secret-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }"
  ]
  ods_policies = [
    "Allow group ${oci_identity_group.ods-group.name} to manage data-science-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow group ${oci_identity_group.ods-group.name} to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow group ${oci_identity_group.ods-group.name} to manage functions-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow group ${oci_identity_group.ods-group.name} to manage api-gateway-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow service datascience to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow service FaaS to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use virtual-network-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to use functions-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage data-science-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage objects ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage dataflow-family ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }" ,
    "Allow dynamic-group ${oci_identity_dynamic_group.ods-dynamic-group.name} to manage public-ips ${data.oci_identity_compartment.current_compartment.id == var.tenancy_ocid ? "in tenancy" : "in compartment ${data.oci_identity_compartment.current_compartment.name}" }"
  ]
}
resource "oci_identity_policy" "ods-policy" {
  provider = oci.home
  compartment_id = var.compartment_ocid
  description = "Data Science Policies"
  name = var.ods_policy_name
  statements = var.enable_vault ? concat(local.ods_policies , local.vault_policies) : local.ods_policies
}

resource "oci_identity_policy" "ods-root-policy" {
  provider = oci.home
  compartment_id = var.tenancy_ocid
  description = "Data Science Root Policies"
  name = var.ods_root_policy_name
  statements = [
    "Allow service FaaS to read repos in tenancy",
    "Allow group ${oci_identity_group.ods-group.name} to manage repos in tenancy"
  ]
}

#*************************************
#             Vault
#*************************************

resource "oci_kms_vault" "ods-vault" {
  count = var.enable_vault ? 1 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name = var.ods_vault_name
  vault_type = var.ods_vault_type
}

resource "oci_kms_key" "ods-key" {
  count = var.enable_vault ? var.enable_create_vault_master_key ? 1 : 0 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name = var.ods_vault_master_key_name
  key_shape {
    #Required
    algorithm = "AES"
    length = var.ods_vault_master_key_length
  }
  management_endpoint = oci_kms_vault.ods-vault[0].management_endpoint
}