#!/bin/bash

#source /home/oracle/.bashrc
# Activate Redbull Environment
source redbullenv/bin/activate

cd /home/opc

if [ "$1" = "start" ]
then
nohup jupyter-lab --ip=0.0.0.0 --port=8001 > ./nohup.log 2>&1 &
echo $! > /home/opc/jupyter.pid
else
kill $(cat /home/opc/jupyter.pid)
fi
