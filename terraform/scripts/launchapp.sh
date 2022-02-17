#!/bin/bash
# Copyright (c) 2021 Oracle and/or its affiliates.

# Activate Redbull Environment
source redbullenv/bin/activate

cd /home/opc/redbull-analytics-hol/beginners/web/

if [ "$1" = "start" ]
then
nohup python3 app.py  > /home/opc/log/app.log 2>&1 &
echo $! > /home/opc/log/app.pid
else
kill $(cat /home/opc/log/app.pid)
fi
