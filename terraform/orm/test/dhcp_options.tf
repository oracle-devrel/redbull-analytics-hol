# Copyright (c) 2021 Oracle and/or its affiliates.

resource oci_core_default_dhcp_options Default-DHCP-Options-for-redbullvcn {
  display_name  = "Default DHCP Options for redbullvcn"
  
  manage_default_resource_id = oci_core_vcn.redbullvcn.default_dhcp_options_id
  
  options {
    custom_dns_servers = []
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }
  
  options {
    search_domain_names = [
      "redbullvcn.oraclevcn.com",
    ]
    
    type = "SearchDomain"
  }
  
  lifecycle {
    ignore_changes = [ defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"] ]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }
}
