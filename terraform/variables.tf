# Copyright (c) 2021 Oracle and/or its affiliates.

variable "ssh_public_key" { 
  type = string
  description = "The public SSH key to use for the compute instance"
  default     = ""
}
variable "ssh_public_key_path" {
  type = string
  description = "The path to the public SSH key to use for the compute instance"
  default     = ""
}

variable "redbull_compartment" {
  type = string
  description = "The name of the compartment created to hold all of the resources"
  default     = "redbullhol"
}

#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
  type = string
  description = "OCI tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five"
}
variable "region" {
  type = string
  description = "OCI Region as documented at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm"
}
variable "compartment_ocid" {
  type = string
  default = ""
  description = "The compartment OCID to deploy resources to"
}
variable "user_ocid" {
  type = string
  default = ""
  description = "OCI user OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five"
}
variable "fingerprint" {
  type = string
  default = ""
  description = "'API Key' fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two"
}
variable "private_key" {
  type = string
  default = ""
  description = "The private key (provided as a string value)"
}
variable "private_key_path" {
  type = string
  default = ""
  description = "Path to private key used to create OCI 'API Key', more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two"
}
variable "private_key_password" {
  type = string
  default = ""
  description = "The password to use for the private key"
}

variable "compute_image_name" {
  type = string
  description = "The name of the compute image to use for the compute instances."
  default = "Oracle-Linux-7.9-2021.08.27-0"
}
