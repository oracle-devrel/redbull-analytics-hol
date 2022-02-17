import os
import sys
import pandas as pd
import numpy as np
from pprint import pprint
import requests
from selenium import webdriver
import time
import datetime
import bs4
from bs4 import BeautifulSoup
# from multiprocessing import Process
from threading import Thread
from dateutil.relativedelta import *

version = "1.0.1"

verbose = False
debug = False
data_path = './data'

def main():
    global data_path
    # args is a list of the command line args
    args = sys.argv[1:]
    # 1. Check for the arg pattern:
    if len(args) >= 1:
        data_path = args[0]
    else:
        data_path = './data'
    # Check Directory exists
    if not os.path.exists(data_path):
        os.mkdir(data_path)
    init_time2 = datetime.datetime.now()
    #
    fullname = os.path.join(data_path, 'races.csv') 
    races = pd.read_csv(fullname)
    fullname = os.path.join(data_path, 'results.csv') 
    results = pd.read_csv(fullname)
    fullname = os.path.join(data_path, 'qualifying.csv') 
    qualifying = pd.read_csv(fullname)
    fullname = os.path.join(data_path, 'driver_standings.csv') 
    driver_standings = pd.read_csv(fullname)
    fullname = os.path.join(data_path, 'constructor_standings.csv') 
    constructor_standings = pd.read_csv(fullname)
    fullname = os.path.join(data_path, 'weather.csv') 
    weather = pd.read_csv(fullname)
    # Clean
    qualifying.rename(columns = {'grid_position': 'grid'}, inplace = True)
    driver_standings.drop(['driver_points_after_race', 'driver_wins_after_race', 'driver_standings_pos_after_race'] ,axis = 1, inplace = True)
    constructor_standings.drop(['constructor_points_after_race', 'constructor_wins_after_race','constructor_standings_pos_after_race' ],axis = 1, inplace = True)

    df1 = pd.merge(races, weather, how='inner', on=['season', 'round', 'circuit_id']).drop(['lat', 'long','country','weather'], axis = 1)
    df2 = pd.merge(df1, results, how='inner', on=['season', 'round', 'circuit_id', 'url']).drop(['url','points', 'status', 'time'], axis = 1)

    df3 = pd.merge(df2, driver_standings, how='left', on=['season', 'round', 'driver']) 
    df4 = pd.merge(df3, constructor_standings, how='left', on=['season', 'round', 'constructor']) #from 1958

    final_df = pd.merge(df4, qualifying, how='inner', on=['season', 'round', 'grid']).drop(['driver_name', 'car'], axis = 1) #from 1983

    #
    # calculate age of drivers
    final_df['date'] = pd.to_datetime(final_df.date)
    final_df['date_of_birth'] = pd.to_datetime(final_df.date_of_birth)
    final_df['driver_age'] = final_df.apply(lambda x: relativedelta(x['date'], x['date_of_birth']).years, axis=1)
    final_df.drop(['date', 'date_of_birth'], axis = 1, inplace = True)

    # fill/drop nulls
    for col in ['driver_points', 'driver_wins', 'driver_standings_pos', 'constructor_points', 
                'constructor_wins' , 'constructor_standings_pos']:
        final_df[col].fillna(0, inplace = True)
        final_df[col] = final_df[col].map(lambda x: int(x))
        
    final_df.dropna(inplace = True )

    # convert to boolean
    for col in ['weather_warm', 'weather_cold','weather_dry', 'weather_wet', 'weather_cloudy']:
        final_df[col] = final_df[col].map(lambda x: bool(x))

    # calculate difference in qualifying times
    final_df['qualifying_time'] = final_df.qualifying_time.map(lambda x: 0 if str(x) == '00.000' 
                                else(float(str(x).split(':')[1]) + (60 * float(str(x).split(':')[0])) if x != 0 else 0))
    final_df = final_df[final_df['qualifying_time'] != 0]
    final_df.sort_values(['season', 'round', 'grid'], inplace = True)
    final_df['qualifying_time_diff'] = final_df.groupby(['season', 'round']).qualifying_time.diff()
    final_df['qualifying_time'] = final_df.groupby(['season', 'round']).qualifying_time_diff.cumsum().fillna(0)
    final_df.drop('qualifying_time_diff', axis = 1, inplace = True)

    # get dummies
    df_dum = pd.get_dummies(final_df, columns = ['circuit_id', 'nationality', 'constructor'] )
    for col in df_dum.columns:
        if 'nationality' in col and df_dum[col].sum() < 140:
            df_dum.drop(col, axis = 1, inplace = True)
            
        elif 'constructor' in col and df_dum[col].sum() < 140:
            df_dum.drop(col, axis = 1, inplace = True)
            
        elif 'circuit_id' in col and df_dum[col].sum() < 70:
            df_dum.drop(col, axis = 1, inplace = True)
        
        else:
            pass

    # save File
    fullname = os.path.join(data_path, 'f1_df_final.csv') 
    df_dum.to_csv(fullname, index = False)
    #
    end_time2 = datetime.datetime.now()
    dif_time2=end_time2-init_time2
    #
    temp=dif_time2.seconds
    hours = temp//3600
    temp = temp - 3600*hours
    minutes = temp//60
    seconds = temp - 60*minutes
    print('Execution Time for HOL1 prepared dataset: %d hour:%d min:%d sec' %(hours,minutes,seconds))


if __name__ == "__main__":
    main()
