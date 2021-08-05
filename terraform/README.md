# Infrastructure Deployment Using Terraform

## Introduction
All of the resources needed to go through this hands-on lab (HOL) may be deployed and maanged via Terraform.  This document gives a couple of techniques to quickly deploy the needed Oracle Cloud Infrastructure (OCI) resources using Terraform.

### Notes
Local OCI groups are used, which can be mapped to a federated group (useful when federating with IDCS, etc.).

## OCI Prerequisites

### Required Permissions
You will need permission to manage the following types of resources in your OCI tenancy, or you may specify a specific compartment:
* `vcns`
* `nat-gateways`
* `route-tables`
* `security-lists`
* `subnets`
* `instances`
* `policies`
* `oci_datascience_project`
* `oci_datascience_notebook_session`
* `oci_identity_tag_namespace`
* `oci_identity_tag`

Permissions for managing the following resource types is needed (at the tenancy level):
* `groups`
* `dynamic-groups`

If you don't have the required permissions, contact your tenancy administrator.  See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm)for more information around IAM permissions.

### Required Resource Limits/Quota
You'll need available resource quotas and permissions to create the following resources:
* 1 x Group (or use an existing group)
* 1 x Dynamic Group
* 1 x IAM Policy
* 1 x VCN
* 1 x Subnet
* 1 x NAT Gateway
* 1 x Route Table
* 1 x Security List
* 1 x Compute instance (1 x VM 2.1 or whatever shape you select)
* 1 x Functions Application
* 1 x Data Science Project (and notebook session)
* 1 x Tag namespace
* 1 x Defined tag

If you don't have the required service limits/quota, contact your tenancy administrator.  See [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm)for more information on service limits and quotas.

## Sign up for an Always-Free tier OCI account

1. Visit the [Oracle Cloud Free Tier](https://signup.cloud.oracle.com/?language=en_US&sourceType=:ow:de:te::::RC_WWMK210628P00062:FreeTierSignup&intcmp=:ow:de:te::::RC_WWMK210628P00062:FreeTierSignup) page.

   Enter your account information and click **Verify my email**.

<img width="1364" alt="sign-up-page" src="https://user-images.githubusercontent.com/12158601/128405323-2df0fb17-a3ab-423c-9836-b6f8b91bd4c8.png">

2. Click the link sent to your email and continue adding account details, including adding payment verification (you won't be charged unless you want to upgrade your Always-free tier account at a later date). 

After reviewing the terms and services for your Oracle Cloud Services account, click **Start my free trial**.

<img width="2047" alt="startMyFreeTrial1" src="https://user-images.githubusercontent.com/12158601/128408494-80de1447-2514-44c3-a8ca-afc0af87453f.png">

3. Wait for your account to be provisioned. This should take approximately two minutes.

<img width="2047" alt="waitForSetUp" src="https://user-images.githubusercontent.com/12158601/128412713-67bf96b2-dd42-4e6b-b4d0-715441e6f2d7.png">

4. After your account is ready, the Get Started tab of your account displays.

<img width="2048" alt="successSignUp" src="https://user-images.githubusercontent.com/12158601/128412847-ed99fb08-36c2-4918-a0c3-ba5b5fc3396d.png">

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

## Deploy Using the OCI Cloud Shell

### Clone the repo
From within your Cloud Shell session, clone the repo:

```
git clone https://github.com/oracle-devrel/redbull-analytics-hol
cd redbull-analytics-hol/terraform
ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup. That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Next, create a `terraform.tfvars` file (feel free to copy the `terraform.tfvars.template` as a starting point) and populate it with the information that's specific to your deployment.  For Cloud Shell, the `region`, `tenancy_ocid`, `compartment_ocid` variables must be provided (at minimum).  Feel free to provide additional variable values (overriding the defaults in `variables.tf`) as-needed for your deployment to customize resource names, behavior, etc.  Here's a sample `terraform.tfvars` file for Cloud Shell:
```
region=""
tenancy_ocid=""
compartment_ocid=""
```
(make sure that you put values in)

Modify the `provider.tf` file, uncommenting the following attributes (in both provider definitions):
```
  ### BEGIN UNCOMMENT FOR OCI CLOUD SHELL
  # auth = "InstancePrincipal"
  ### END UNCOMMENT FOR OCI CLOUD SHELL
```

### Create the Resources
Run the following commands from within the Cloud Shell session:

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

## Deploy Using the Terraform CLI

### Clone the repo
You'll want a local copy of this repo.  You can do this via SSH with the following:

```
git clone git@github.com:oracle-devrel/redbull-analytics-hol.git
cd redbull-analytics-hol/terraform
ls
```

Or you can use HTTPS (instead of SSH):

```
git clone https://github.com/oracle-devrel/redbull-analytics-hol
cd redbull-analytics-hol/terraform
ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup. That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Next, create a `terraform.tfvars` file (feel free to copy the `terraform.tfvars.template` as a starting point) and populate it with the information that's specific to your deployment, particularly the `region`, `user_ocid`, `tenancy_ocid`, `compartment_ocid`, `private_key_path` (or paste the contents of your private key into the `private_key` variable) and `fingerprint` variables.  Feel free to provide additional variable values (overriding the defaults in `variables.tf`) as-needed for your deployment to customize resource names, behavior, etc.  Here's a sample `terraform.tfvars` file for Cloud Shell:
```
region=""
tenancy_ocid=""
compartment_ocid=""
user_ocid=""
private_key_path=""
#### USE ONE ^ OR THE OTHER v
private_key_password=""
fingerprint=""
```
(make sure that you put values in)

Modify the `provider.tf` file, uncommenting the following attributes (in both provider definitions):
```
  ### BEGIN UNCOMMENT FOR TERRAFORM CLI (running locally)
  # user_ocid = var.user_ocid
  # fingerprint = var.fingerprint
  # private_key = local.private_key
  #### USE ONE ^ OR THE OTHER v
  # private_key_path = var.private_key_path
  # private_key_password = var.private_key_password
  ### END UNCOMMENT FOR TERRAFORM CLI (running locally)
```

Note that only `private_key` or `private_key_path` is needed (no need to use both).

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
