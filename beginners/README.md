# Beginners Hands-On Lab

## Prerequisites

You'll need an OCI free trial account: <a href="https://signup.cloud.oracle.com/?sourceType=_ref_coc-asset-opcSignIn&language=en_US" target="_blank" title="Sign up for free trial">click here to sign up</a> (right click and open in a new tab so you can keep these instructions open). We're going to use a ready-to-go image to install the required resources, so all you need to start is a free account.

Registered lab participants should have received $500 in credits to use for Data Science operations.

Here's [a video to help with signing up.](https://www.youtube.com/watch?v=4U-0SumNz6w)

## Lab Guide

A PDF version of the slide deck for this lab is [available here](./docs/Red-Bull-HOL.pdf) (right click to save to disk or open in a new tab).

### SSH Key

You'll also need an SSH key pair to access the OCI Stack we're going to create. For Mac/Linux systems, you can [use `ssh-keygen`](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#ariaid-title4). On Windows, you'll [use PuTTY Key Generator](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#ariaid-title5). Again, right click the appropriate link and open in a new tab so you don't lose this page.

To summarize Mac/Linux:

    ssh-keygen -t rsa -N "" -b 2048 -C "<key_name>" -f <path/root_name> 

For Windows, and step-by-step instructions for Mac/Linux, please see the [Oracle Docs on Managing Key Pairs](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#Managing_Key_Pairs_on_Linux_Instances).

## Getting Started

1. Click the button below to begin the deploy of the Data Science stack and custom image:
    
    <a href="https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/redbull-analytics-hol/releases/latest/download/redbull-analytics-hol-latest.zip" target="_blank"><img src="https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg" alt="Deploy to Oracle Cloud"/></a>
2. If needed, log into your account. You should then be presented with the **Create Stack** page. 
    
    These next few steps will deploy a stack to your OCI tenancy. This will include a Compute instance and the necessary tools to deploy and run Jupyter Lab from within your OCI account.

    Under *Stack Information* (the first screen), check the box *I have reviewed and accept the Oracle Terms of Use*. Once that box is checked, the information for the stack will be populated automatically.
    
    ![Create Stack](./docs/red-bull-hol-1a-create-stack-information.jpg)
3. Click **Next** at the bottom of the screen. This will take you to the **Configure Variables** page. On this page you'll need to provide the SSH key we created in the prerequisites. If you want your Compute instance to function after your Free Trial ends, check the box for an Always Free Shape. Then click **Next** again.

    ![Configure Variables](./docs/red-bull-hol-configure-variables.jpg)
4. On the **Review** page, be sure *Run Apply* is checked, and click **Create**.

    ![Review and Create](./docs/red-bull-hol-1c-create-stack-review.jpg)
5. This will take you to the **Job Details** page, and OCI will begin creating the stack and deploying the custom image for the lab. This will take about 11 minutes. When it completes (assuming everything went smoothly), the **Job Details** will show a bright green square with "Succeeded" below it.
    
    ![Create Stack Succeeded](./docs/red-bull-hol-1d-create-stack-succeeded.jpg)
6. Once the Create Stack job has succeeded, click the hamburger menu in the upper left, select **Compute** in the sidebar, and click **Instances** in the menu.

    ![Instances in the Menu](./docs/red-bull-hol-2a-menu-instances.jpg)
7. On the **Instances** screen, make sure "redbullhol" is selected under *Compartment*. If "redbullhol" isn't in the dropdown menu, you may need to refresh the page for the new compartent to show up.

    ![Instances Compartment](./docs/red-bull-hol-2c-instances-compartment.jpg)
8. Once the "redbullhol" compartment is selected, you should see a running Instance in the list. The address you'll need to access it is in the *Public IP* column. Copy the IP address shown.

    ![Public IP](./docs/red-bull-hol-2d-instances-public-ip.jpg)
9. Next, open a new tab in your browser to load up the web UI for Jupyter Lab. Paste the IP address you just copied with `:8888` added to the end. The URL should look like `https://xxx.xxx.xxx.xxx:8888` (substituting the public IP we copied in the previous step). Jupyter Lab is running on port 8888, so when you navigate to this URL you should see the Juypter login.

    _**Note:** You should not be on VPN when opening Jupyter Lab._

    ![Jupyter Login](./docs/red-bull-hol-3b-jupyter-login.jpg)
10. Log in with the password `Redbull1`.
11. You should now see the Jupyter Lab. Navigate in the sidebar to `/redbull-analytics-hol/beginners/` to see the Jupyter notebooks for this lab.

The notebooks are numbered and you'll progress through them in order. These will walk you through collecting and analyzing the data we'll use to predict some races.


## Using the Jupyter Lab

The Jupyter notebooks are ordered by number, and you'll progress through them in sequence. 

All of the data and models for this lab are already stored in this directory. You can run the notebooks to see what they do, but it's not required to see the finished product. Note that running the notebook `04.ML_Modelling` takes about 40 minutes, so if you want to play with it, save it until after the live lab.

These notebooks use data gathered from ergast.com. The data gathering process takes some time, so we've gone ahead and pulled the data in for you. However, if you want to see how it's done, take a look in the `from_scratch` directory, where you'll find the original scripts that gathered the remote data.

See the notes in each notebook for a bit of explanation as you go. If you have a basic understanding of Python, you should also be able to see the nitty gritty of what's happening.

## Developer Journey Map

View each notebook in numeric order:

- 01_0.Formule1_Data_Collection.ipynb
- 01_1.Weather_Data_Collection.ipynb
- 01_2.Qualifying_Data_Collection.ipynb
- 02.Data_Preparation_merging.ipynb
- 03.f1_analysis_EDA.ipynb
- 04.ML_Modelling.ipynb
- 05.ML_Model_Serving.ipynb

## Making Your Own Modifications

Once you've tested the notebooks as they are, you can make changes to `04.ML_Modelling.ipynb` to experiment with different inputs and see the results.

## Starting The Web Application

To see the results of the lab, you'll need to start the web server using Terminal.

1. In the menu at the top of the page, select **File->New->Terminal**.
2. Enter the following commands, hitting return after each one (feel free to copy and paste)

        cd /home/opc/redbull-analytics-hol/beginners/web
        ./launchapp.sh start

    To stop the server later, if needed, use:

        ./launchapp.sh stop
3. Open a web browser to the public IP of your Jupyter Lab, but use port 8443 instead of port 8888:

        https://xxx.xxx.xxx.xxx:8443

    The Public IP is the one at which you're currently accessing Jupyter Lab, which we copied from the Running Instances step above.
