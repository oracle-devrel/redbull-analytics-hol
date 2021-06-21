# Infrastructure Deployment Using Terraform

## Introduction
All of the resources needed to go through this hands-on lab (HOL) may be deployed and maanged via Terraform.  This document gives a couple of techniques to quickly deploy the needed Oracle Cloud Infrastructure (OCI) resources using Terraform.

### Notes
Local OCI groups are used, which can be mapped to a federated group (useful when federating with IDCS, etc.).

## OCI Prerequisites

### Required Permissions
You will need permission to manage the following types of resources in your OCI tenancy:
* `vcns`
* `internet-gateways`
* `load-balancers`
* `route-tables`
* `security-lists`
* `subnets`
* `instances`

If you don't have the required permissions, contact your tenancy administrator.  See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm)for more information around IAM permissions.

### Required Resource Limits/Quota
You'll need available resource quotas to create the following resources:
* 1 VCN
* 3 subnets
* 1 Internet Gateway
* 1 NAT Gateway
* 2 route rules
* 1 compute instance (1 x VM 2.1)

If you don't have the required service limits/quota, contact your tenancy administrator.  See [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm)for more information on service limits and quotas.

## Deploy Using Oracle Resource Manager
1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/redbull-analytics-hol/releases/latest/download/redbull-analytics-hol-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 


## Deploy Using the Terraform CLI

### Clone the repo

You'll want a local copy of this repo.  You can do this via SSH with the following:

```
git clone git@github.com:oracle-devrel/redbull-analytics-hol.git
cd redbull-analytics-hol
ls
```

Or you can use HTTPS (instead of SSH):

```
git clone https://github.com/oracle-devrel/redbull-analytics-hol
cd formule1-analytics-hol/beginners
ls
```

### Prerequisites

First off, you'll need to do some pre-deploy setup. That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Next, update the `terraform.tfvars` file and populate it with the information that's specific to your deployment, particularly the `region`, `user_ocid`, `tenancy_ocid`, `private_key_path` and `fingerprint` variables.

### Create the Resources
Run the following commands:

```
terraform init
terraform plan
terraform apply
```

### Destroy the Deployment

When you no longer need the deployment, you can run this command to destroy the resources:

```
terraform destroy
```
