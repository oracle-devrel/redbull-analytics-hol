#!/bin/bash
# Copyright (c) 2021 Oracle and/or its affiliates.

su opc -c "mkdir /home/opc/log"

# if quickstart
([[ ! -z "$1" ]] && [ $1 -eq 1 ] 2>/dev/null) && {
   
su opc -c "/home/opc/quickstart.sh"     
}

# create script to start, stop service "jupyterlab"
cat /home/opc/jupyterlab.service > /etc/systemd/system/jupyterlab.service

# Test Service
systemctl start jupyterlab
systemctl status jupyterlab
systemctl enable jupyterlab

# reboot machine to check that jupyterlab is enabled by default on port 8001

# Open ports to the machine VM2.1
firewall-cmd  --permanent --zone=public --list-ports
firewall-cmd --get-active-zones
firewall-cmd --permanent --zone=public --add-port=8888/tcp
firewall-cmd --permanent --zone=public --add-port=8443/tcp
firewall-cmd --reload

