# Copyright (c) 2021 Oracle and/or its affiliates.

data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}

data "oci_identity_regions" "current_region" {
  filter {
    name   = "name"
    values = [var.region]
  }
}

data "oci_identity_compartment" "current_compartment" {
  id = var.compartment_ocid
}

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid
  
  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data oci_identity_availability_domain AD1 {
  compartment_id = var.compartment_ocid
  ad_number      = "1"
}

data "oci_core_images" "this" {
  compartment_id = var.compartment_ocid
  filter {
    name = "state"
    values = ["AVAILABLE"]
  }
}
