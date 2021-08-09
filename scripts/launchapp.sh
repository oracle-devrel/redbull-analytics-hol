#!/bin/bash

# Activate Redbull Environment
source redbullenv/bin/activate

cd /home/opc/redbull-analytics-hol/beginners/web/

if [ "$1" = "start" ]
then
nohup python3 app.py  > /home/opc/nohup_app.log 2>&1 &
echo $! > /home/opc/app.pid
else
kill $(cat /home/opc/app.pid)
fi
