# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           ODS Specific
#*************************************

variable "ods_project_name" {
  default = "Data Science Project"
  description = "ODS Default Project Name"
}
variable "ods_notebook_name" {
  default = "Data Science Notebook"
  description = "ODS Notebook Name"
}
# Supported VM Shapes:
#    - VM.Standard.E2.2
#    - VM.Standard.E2.4
#    - VM.Standard.E2.8
#    - VM.Standard2.1
#    - VM.Standard2.2
#    - VM.Standard2.4
#    - VM.Standard2.8
#    - VM.Standard2.16
#    - VM.Standard2.24
# VM Shapes Specs details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#virtualmachines
variable "ods_compute_shape" {
  default = "VM.Standard2.1"
  description = "Default Compute shape to use for a Notebook.  See https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#virtualmachines for more info."
}
variable "ods_storage_size" {
  default = 50
}
variable "ods_number_of_notebooks" {
  default = 1
}
variable "enable_ods" {
  type    = bool
  default = true
  description = "Provision ODS Project and Notebook?"
}

# #*************************************
# #    Functions/API Gateway Specific
# #*************************************
variable "enable_functions" {
  type = bool
  default = true
  description = "Provision Functions Application?"
}
variable "functions_app_name" {
  default = "DataScienceApp"
  description = "Name of the 'Functions Application' (no spaces are allowed)"
}

#*************************************
#         Network Specific
#*************************************

variable "ods_vcn_name" {
  default = "Data Science VCN"
  description = "VCN Name Default Name. Only Applies if 'ods_vcn_use_existing' is set to false"
}
variable "ods_vcn_cidr" {
  default = "10.0.0.0/16"
  description = "VCN CIDR Space. Only Applies if 'ods_vcn_use_existing' is set to false"
}
variable "ods_subnet_private_name" {
  default = "Data Science - Private"
  description = "Private Subnet Default Name. Only Applies if 'ods_vcn_use_existing' is set to false"
}
variable "ods_subnet_private_cidr" {
  default = "10.0.1.0/24"
  description = "Private Subnet CIDR Space. Only Applies if 'ods_vcn_use_existing' is set to false"
}
variable "ods_vcn_use_existing" {
  default = false
  description = "Use an existing VCN or create a new VCN along with all its related artifacts?"
}
variable "ods_vcn_existing" {
  default = ""
  description = "Existing VCN OCID. Only Applies if 'ods_vcn_use_existing' is set to true"
}
variable "ods_subnet_private_existing" {
  default = ""
  description = "Existing Private Subnet OCID. Only Applies if 'ods_vcn_use_existing' is set to true. Subnet must exists within the selected 'existing VCN'"
}

#*************************************
#          IAM Specific
#*************************************

variable "create_ods_group" {
  type    = bool
  default = true
  description = "Whether to create a new group for ODS (true) or use an existing one (false)."
}
variable "ods_group_name" {
  default = "DataScienceGroup"
  description = "ODS IAM Group Name (no spaces)"
}
variable "ods_dynamic_group_name" {
  default = "DataScienceDynamicGroup"
  description = "ODS IAM Dynamic Group Name (no spaces)"
}
variable "ods_policy_name" {
  default = "DataSciencePolicies"
  description = "ODS IAM Policy Name (no spaces)"
}

#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
  description = "OCI tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five"
}
variable "region" {
  description = "OCI Region as documented at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm"
}
variable "compartment_ocid" {
  default = ""
  description = "The compartment OCID to deploy resources to"
}
variable "user_ocid" {
  default = ""
  description = "OCI user OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five"
}
variable "fingerprint" {
  default = ""
  description = "'API Key' fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two"
}
variable "private_key" {
  default = ""
  description = "The private key (provided as a string value)"
}
variable "private_key_path" {
  default = ""
  description = "Path to private key used to create OCI 'API Key', more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two"
}
variable "private_key_password" {
  default = ""
  description = "The password to use for the private key"
}


#*************************************
#        Local Variables
#*************************************
locals {
  private_subnet_id = var.ods_vcn_use_existing ? var.ods_subnet_private_existing : oci_core_subnet.ods-private-subnet[0].id
  private_key = try(file(var.private_key_path), var.private_key)
}