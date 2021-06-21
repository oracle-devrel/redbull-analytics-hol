# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           ODS Specific
#*************************************

variable "ods_project_name" {
  default = "Data Science Project"
}
variable "ods_notebook_name" {
  default = "Data Science Notebook"
}
variable "ods_compute_shape" {
  default = "VM.Standard2.1"
}
variable "ods_storage_size" {
  default = 50
}
variable "ods_number_of_notebooks" {
  default = 1
}
variable "enable_ods" {
  type = bool
  default = true
}

#*************************************
#    Functions/API Gateway Specific
#*************************************
variable "enable_functions_apigateway" {
  type = bool
  default = false
}
variable "functions_app_name" {
  default = "DataScienceApp"
}
variable "apigateway_name" {
  default = "Data Science Gateway"
}

#*************************************
#         Network Specific
#*************************************

variable "ods_vcn_name" {
  default = "Data Science VCN"
}
variable "ods_vcn_cidr" {
  default = "10.0.0.0/16"
}
variable "ods_subnet_public_name" {
  default = "Data Science - Public"
}
variable "ods_subnet_public_cidr" {
  default = "10.0.0.0/24"
}
variable "ods_subnet_private_name" {
  default = "Data Science - Private"
}
variable "ods_subnet_private_cidr" {
  default = "10.0.1.0/24"
}
variable "ods_vcn_use_existing" {
  default = false
}
variable "ods_vcn_existing" {
  default = ""
}
variable "ods_subnet_public_existing" {
  default = ""
}
variable "ods_subnet_private_existing" {
  default = ""
}

#*************************************
#          IAM Specific
#*************************************

variable "ods_group_name" {
  default = "DataScienceGroup"
}
variable "ods_dynamic_group_name" {
  default = "DataScienceDynamicGroup"
}
variable "ods_policy_name" {
  default = "DataSciencePolicies"
}
variable "ods_root_policy_name" {
  default = "DataScienceRootPolicies"
}

#*************************************
#          Vault Specific
#*************************************
variable "enable_vault" {
  type = bool
  default = false
}
variable "ods_vault_name" {
  default = "Data Science Vault"
}
variable "ods_vault_type" {
  default = "DEFAULT"
}
variable "enable_create_vault_master_key" {
  type = bool
  default = false
}
variable "ods_vault_master_key_name" {
  default = "DataScienceKey"
}
variable "ods_vault_master_key_length" {
  default = 32
}
#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
}
variable "region" {
}
variable "compartment_ocid" {
}

#*************************************
#        Local Variables
#*************************************
locals {
  public_subnet_id = var.ods_vcn_use_existing ? var.ods_subnet_public_existing : oci_core_subnet.ods-public-subnet[0].id
  private_subnet_id = var.ods_vcn_use_existing? var.ods_subnet_private_existing : oci_core_subnet.ods-private-subnet[0].id
}

#*************************************
#           Data Sources
#*************************************

data "oci_identity_tenancy" "tenant_details" {
  #Required
  tenancy_id = var.tenancy_ocid
}
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [var.region]
  }
}
data "oci_identity_regions" "current_region" {
  filter {
    name = "name"
    values = [var.region]
  }
}
data "oci_identity_compartment" "current_compartment" {
  #Required
  id = var.compartment_ocid
}