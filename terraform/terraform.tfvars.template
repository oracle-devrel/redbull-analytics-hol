# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#           ODS Specific
#*************************************
// Provision ODS Project and Notebook
enable_ods=true
// ODS Default Project Name
ods_project_name= "Redbull Beginners HOL Project"
// ODS Notebook Name
ods_notebook_name = "Redbull Beginners HOL Notebook"
// Default Compute shape to use for a Notebook. Supported VM Shapes:
//    - VM.Standard.E2.2
//    - VM.Standard.E2.4
//    - VM.Standard.E2.8
//    - VM.Standard2.1
//    - VM.Standard2.2
//    - VM.Standard2.4
//    - VM.Standard2.8
//    - VM.Standard2.16
//    - VM.Standard2.24
// VM Shapes Specs details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#virtualmachines
ods_compute_shape="VM.Standard2.1"
// Notebook sotrage size in GB, minimum is 50 and maximum is 1024 (1TB)
ods_storage_size="50"
// Number of Notebooks to provision, default is 1.
ods_number_of_notebooks=1

#*************************************
#    Functions/API Gateway Specific
#*************************************

// Provision Functions Application and its associated API Gateway
enable_functions_apigateway=false
// Name of the "Functions Application", no spaces are allowed
functions_app_name="RedbullBeginnersHOLApp"
// Name of the "API Gateway"
apigateway_name="Redbull Beginners HOL Gateway"

#*************************************
#         Network Specific
#*************************************

// Use an existing VCN or create a new VCN along with all its related artifacts
ods_vcn_use_existing = false

// VCN Name Default Name. Only Applies if "ods_vcn_use_existing" is set to false
ods_vcn_name="Data Science VCN"
// VCN CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
ods_vcn_cidr="10.0.0.0/16"
// Public Subnet Default Name. Only Applies if "ods_vcn_use_existing" is set to false
ods_subnet_public_name="Data Science - Public"
// Public Subnet CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
ods_subnet_public_cidr = "10.0.0.0/24"
// Private Subnet Default Name. Only Applies if "ods_vcn_use_existing" is set to false
ods_subnet_private_name = "Data Science - Private"
// Private Subnet CIDR Space. Only Applies if "ods_vcn_use_existing" is set to false
ods_subnet_private_cidr = "10.0.1.0/24"

// Existing VCN OCID. Only Applies if "ods_vcn_use_existing" is set to true
ods_vcn_existing= ""
// Existing Public Subnet OCID. Only Applies if "ods_vcn_use_existing" is set to true. Subnet must exists within the selected "existing VCN"
ods_subnet_public_existing = ""
// Existing Private Subnet OCID. Only Applies if "ods_vcn_use_existing" is set to true. Subnet must exists within the selected "existing VCN"
ods_subnet_private_existing = ""

#*************************************
#          IAM Specific
#*************************************

// ODS IAM Group Name (no spaces)
ods_group_name= "DataScienceGroup"
// ODS IAM Dynamic Group Name (no spaces)
ods_dynamic_group_name= "DataScienceDynamicGroup"
// ODS IAM Policy Name (no spaces)
ods_policy_name= "DataSciencePolicies"
// ODS IAM Root Policy Name (no spaces)
ods_root_policy_name= "DataScienceRootPolicies"


#*************************************
#          Vault Specific
#*************************************
// If enabled, an OCI Vault along with the needed OCI policies to manage "Vault service" will be created
enable_vault= false
// ODS Vault Name
ods_vault_name= "Data Science Vault"
// ODS Vault Type, allowed values (VIRTUAL, DEFAULT)
ods_vault_type = "DEFAULT"
// If enabled, a Vault Master Key will be created.
enable_create_vault_master_key = false
// ODS Vault Master Key Name
ods_vault_master_key_name = "DataScienceKey"
// ODS Vault Master Key length, allowed values (16, 24, 32)
ods_vault_master_key_length = 32


#*************************************
#           TF Requirements
#*************************************

// OCI Region, user "Region Identifier" as documented here https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
// region=""
// The Compartment OCID to provision artificats within
// compartment_ocid=""
// OCI User OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
// user_ocid=""
// OCI tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
// tenancy_ocid=""
// Path to private key used to create OCI "API Key", more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
// private_key_path=""
// "API Key" fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
// fingerprint=""
