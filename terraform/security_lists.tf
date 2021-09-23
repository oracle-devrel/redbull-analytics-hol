# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_default_security_list Default-Security-List-for-redbullvcn {
  display_name = "Default Security List for redbullvcn"

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"

    protocol  = "all"
    stateless = "false"
  }

  ingress_security_rules {
    description = "SSH"
    protocol = "6"

    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    description = "Jupyter lab"
    protocol = "6"

    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"

    tcp_options {
      max = "8888"
      min = "8888"
    }
  }

  ingress_security_rules {
    description = "Predictor Web Service"
    protocol = "6"

    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"

    tcp_options {
      max = "8443"
      min = "8443"
    }
  }

  ingress_security_rules {
    icmp_options {
      code = "4"
      type = "3"
    }

    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }

  ingress_security_rules {
    icmp_options {
      code = "-1"
      type = "3"
    }

    protocol    = "1"
    source      = "192.168.1.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }

  manage_default_resource_id = oci_core_vcn.redbullvcn.default_security_list_id
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}