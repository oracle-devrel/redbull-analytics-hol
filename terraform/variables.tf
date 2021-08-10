# Copyright (c) 2021 Oracle and/or its affiliates.

variable "ssh_public_key" { 
  description = "The public SSH key to use for the compute instance"
  default     = ""
}

variable "redbull_compartment" {
  description = "The name of the compartment created to hold all of the resources"
  default     = "redbullhol"
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
  private_key = try(file(var.private_key_path), var.private_key)
  release = "1.0"
}