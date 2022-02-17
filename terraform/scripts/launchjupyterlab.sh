#!/bin/bash
# Copyright (c) 2021 Oracle and/or its affiliates.

# Activate Redbull Environment
source redbullenv/bin/activate

cd /home/opc

if [ "$1" = "start" ]
then
nohup jupyter-lab --ip=0.0.0.0 --port=8888 --certfile=/home/opc/lab.crt --keyfile=/home/opc/lab.key > /home/opc/log/jupyterlab.log 2>&1 &
echo $! > /home/opc/log/jupyter.pid
else
kill $(cat /home/opc/log/jupyter.pid)
fi
