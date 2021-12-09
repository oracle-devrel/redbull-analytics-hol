# Copyright (c) 2020-2021 Oracle and/or its affiliates.

terraform {
  required_version = ">= 0.13.5"
}

# Default Provider
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  
  ### FOR ORM USAGE, COMMENT THE TERRAFORM CLI AND OCI CLOUD SHELL SECTIONS
  
  ### BEGIN UNCOMMENT FOR TERRAFORM CLI (running locally)
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key = local.private_key
  private_key_password = var.private_key_password
  ### END UNCOMMENT FOR TERRAFORM CLI (running locally)
  
  ### BEGIN UNCOMMENT FOR OCI CLOUD SHELL
  # auth = "InstancePrincipal"
  ### END UNCOMMENT FOR OCI CLOUD SHELL
}

# Home Provider
provider "oci" {
  alias        = "home"
  region       = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  tenancy_ocid = var.tenancy_ocid
  
  ### FOR ORM USAGE, COMMENT THE TERRAFORM CLI AND OCI CLOUD SHELL SECTIONS
  
  ### BEGIN UNCOMMENT FOR TERRAFORM CLI (running locally)
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key = local.private_key
  private_key_password = var.private_key_password
  ### END UNCOMMENT FOR TERRAFORM CLI (running locally)
  
  ### BEGIN UNCOMMENT FOR OCI CLOUD SHELL
  # auth = "InstancePrincipal"
  ### END UNCOMMENT FOR OCI CLOUD SHELL
}