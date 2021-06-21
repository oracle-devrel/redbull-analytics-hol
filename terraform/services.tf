# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           API Gateway
#*************************************

// Gateway
resource oci_apigateway_gateway ods-gateway {
  count = var.enable_functions_apigateway ? 1 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name = var.apigateway_name
  endpoint_type = "PUBLIC"
  subnet_id = local.public_subnet_id
}

#*************************************
#           Functions
#*************************************
// App
resource "oci_functions_application" "ods-application" {
  count = var.enable_functions_apigateway ? 1 : 0
  #Required
  compartment_id = var.compartment_ocid
  display_name = var.functions_app_name
  subnet_ids = [local.private_subnet_id]
}