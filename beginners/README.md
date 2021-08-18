# Beginners Hands-On Lab

## Prerequisites

You'll need an OCI free trial account: <a href="https://signup.cloud.oracle.com/?sourceType=_ref_coc-asset-opcSignIn&language=en_US" target="_blank" title="Sign up for free trial">click here to sign up</a> (right click and open in a new tab so you can keep these instructions open). We're going to use a ready-to-go image to install the required resources, so all you need to start is a free account.

Registered lab participants should have received $500 in credits to use for Data Science operations.

Here's [a video to help with signing up.](https://www.youtube.com/watch?v=4U-0SumNz6w)

## Lab Guide

A PDF version of the slide deck for this lab is [available here](https://raw.githubusercontent.com/oracle-devrel/redbull-analytics-hol/main/beginners/docs/Red-Bull-HOL.pdf) (right click to save to disk or open in a new tab).

### SSH Key

You'll also need an SSH key pair to access the OCI Stack we're going to create. For Mac/Linux systems, you can [use `ssh-keygen`](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#ariaid-title4). On Windows, you'll [use PuTTY Key Generator](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#ariaid-title5). Again, right click the appropriate link and open in a new tab so you don't lose this page.

To summarize Mac/Linux:

    ssh-keygen -t rsa -N "" -b 2048 -C "<key_name>" -f <path/root_name> 

For Windows, and step-by-step instructions for Mac/Linux, please see the [Oracle Docs on Managing Key Pairs](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#Managing_Key_Pairs_on_Linux_Instances).

## Getting Started

1. Click the button below to begin the deploy of the Data Science stack and custom image:
    
    <a href="https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/redbull-analytics-hol/releases/latest/download/redbull-analytics-hol-latest.zip" target="_blank"><img src="https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg" alt="Deploy to Oracle Cloud"/></a>
2. If needed, log into your account. You should then be presented with the **Create Stack** page. 
    
    These next few steps will deploy a stack to your OCI tenancy. This will include a Compute instance and the necessary tools to deploy and run JupyterLab from within your OCI account.

    Under *Stack Information* (the first screen), check the box *I have reviewed and accept the Oracle Terms of Use*. Once that box is checked, the information for the stack will be populated automatically.
    
    ![Create Stack](./docs/red-bull-hol-1a-create-stack-information.jpg)
3. Click **Next** at the bottom of the screen. This will take you to the **Configure Variables** page. On this page you'll need to provide the SSH key we created in the prerequisites if you want SSH access to your Compute instance.

    ![Configure Variables](./docs/red-bull-hol-configure-variables.jpg)
4. On the **Review** page, be sure *Run Apply* is checked, and click **Create**.

    ![Review and Create](./docs/red-bull-hol-1c-create-stack-review.jpg)
5. This will take you to the **Job Details** page, and OCI will begin creating the stack and deploying the custom image for the lab. This will take about 11 minutes. When it completes (assuming everything went smoothly), the **Job Details** will show a bright green square with "Succeeded" below it.
    
    ![Create Stack Succeeded](./docs/red-bull-hol-1d-create-stack-succeeded.jpg)
6. Once the Create Stack job has succeeded, click the hamburger menu in the upper left, select **Compute** in the sidebar, and click **Instances** in the menu.

    ![Instances in the Menu](./docs/red-bull-hol-2a-menu-instances.jpg)
7. On the **Instances** screen, make sure "redbullhol" is selected under *Compartment*. If "redbullhol" isn't in the dropdown menu, you may need to refresh the page for the new compartment to show up.

    ![Instances Compartment](./docs/red-bull-hol-2c-instances-compartment.jpg)
8. Once the "redbullhol" compartment is selected, you should see a running Instance in the list. The address you'll need to access it is in the *Public IP* column. Copy the IP address shown.

    ![Public IP](./docs/red-bull-hol-2d-instances-public-ip.jpg)
9. Next, open a new tab in your browser to load up the web UI for JupyterLab. Paste the IP address you just copied with `:8001` added to the end. The URL should look like `http://xxx.xxx.xxx.xxx:8001` (substituting the public IP we copied in the previous step). JupyterLab is running on port 8001, so when you navigate to this URL you should see the Juypter login.

    _**Note:** You should not be on VPN when opening JupyterLab._

    ![Jupyter Login](./docs/red-bull-hol-3b-jupyter-login.jpg)
10. Log in with the password `Redbull1`.
11. You should now see the JupyterLab. Navigate in the sidebar to `/redbull-analytics-hol/beginners/` to see the Jupyter notebooks for this lab.

## Up and Running

From this point on, please refer to the slide deck being presented on Zoom. You can use [the PDF](https://raw.githubusercontent.com/oracle-devrel/redbull-analytics-hol/main/beginners/docs/Red-Bull-HOL.pdf) for reference as you go.

## Starting The Web Application

When you get through the notebooks, you'll need to start the web server to see your results. We're including these commands here in the README for clarity (and so you can copy/paste).

1. In the JupyterLab menu at the top of the page, select **File->New->Terminal**.
2. Enter the following commands, hitting return after each one (feel free to copy and paste)

        ./launchapp.sh start

    To stop the server later, if needed, use:

        ./launchapp.sh stop
3. Open a web browser to the public IP of your JupyterLab, but use port 8080 instead of port 8001:

        http://xxx.xxx.xxx.xxx:8080

    The Public IP is the one at which you're currently accessing JupyterLab, which we copied from the Running Instances step above.
