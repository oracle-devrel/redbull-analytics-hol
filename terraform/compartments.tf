# Copyright (c) 2021 Oracle and/or its affiliates.

resource "oci_identity_compartment" "redbullhol" {
  compartment_id = var.compartment_ocid
  description = "RedBull HOL Compartment."
  name = var.redbull_compartment
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [oci_identity_compartment.redbullhol]

  create_duration = "60s"
}