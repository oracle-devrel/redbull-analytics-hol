#!/bin/bash

# Install all next libraries:
#ads-lite (v2.1.0),oci (v2.21.3),pandas (v1.1),pandarallel (v1.5.1),dask (v2.16),kafka-python (v2.0.0),seaborn (v0.10.1),matplotlib (v3.3.1),plotly (v4.9.0)

odsc conda install -s dataexpl_p37_cpu_v1

# Activate the environment to use all libraries installed
source activate /home/datascience/conda/dataexpl_p37_cpu_v1

pip install -y lxml==4.6.3
conda install -y selenium
conda install -y beautifulsoup4
