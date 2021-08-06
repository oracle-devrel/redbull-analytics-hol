# Copyright (c) 2021 Oracle and/or its affiliates.

resource "random_id" "tag" {
  byte_length = 2
}

resource "oci_identity_tag_namespace" "devrel" {
  provider = oci.home
  compartment_id = var.compartment_ocid
  description = "Developer Relations Tag Namespace"
  name = "DevRel\\redbull-analytics-hol-${random_id.tag.hex}"
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "oci_identity_tag" "release" {
  provider = oci.home
  description = "Release tag."
  name = "release"
  tag_namespace_id = oci_identity_tag_namespace.devrel.id
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  provisioner "local-exec" {
    command = "sleep 120"
  }
}
