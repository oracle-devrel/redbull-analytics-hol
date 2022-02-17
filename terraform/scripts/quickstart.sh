#!/bin/bash
# Copyright (c) 2021 Oracle and/or its affiliates.

# Activate Redbull Environment
BASE=/home/opc/

cd $BASE/
source redbullenv/bin/activate

python3 extract_fone_races.py redbull-analytics-hol/beginners/data  > $BASE/log/extract_fone_races.log

python3 generate_fone_dataset.py  redbull-analytics-hol/beginners/data > $BASE/log/generate_fone_dataset.log &

wget http://ergast.com/downloads/f1db_csv.zip -O $BASE/tmp.zip
unzip $BASE/tmp.zip -d $BASE/redbull-analytics-hol/beginners/data_f1
rm $BASE/tmp.zip

cd $BASE/redbull-analytics-hol/beginners/
runipy 03.f1_analysis_EDA.ipynb
runipy res/04.ML_Modelling_solution.ipynb
runipy 05.ML_Model_Serving.ipynb

cd $BASE/
./launchapp.sh start
