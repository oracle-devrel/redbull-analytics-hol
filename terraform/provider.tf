# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 0.12"
}

// Default Provider
provider "oci" {
  region = var.region
  tenancy_ocid = var.tenancy_ocid
  ###### Uncomment the below if running locally using terraform and not as OCI Resource Manager stack #####
//  user_ocid = var.user_ocid
//  fingerprint = var.fingerprint
//  private_key_path = var.private_key_path

}

// Home Provider
provider "oci" {
  alias            = "home"
  region           = var.region
  tenancy_ocid = var.tenancy_ocid
  ###### Uncomment the below if running locally using terraform and as not OCI Resource Manager stack #####
//  user_ocid = var.user_ocid
//  fingerprint = var.fingerprint
//  private_key_path = var.private_key_path

}