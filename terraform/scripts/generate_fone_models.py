# Copyright (c) 2021 Oracle and/or its affiliates.

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
#
import matplotlib.pyplot as plt
import seaborn as sns
import pickle
from sklearn.metrics import confusion_matrix, precision_score
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler,LabelEncoder,OneHotEncoder
from sklearn.model_selection import cross_val_score,StratifiedKFold,RandomizedSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import confusion_matrix,precision_score,f1_score,recall_score
from sklearn.neural_network import MLPClassifier, MLPRegressor


version = "1.0.1"

verbose = False
debug = False
data_path = './data_f1'


def position_index(x):
    if x<4:
        return 1
    if x>10:
        return 3
    else :
        return 2

def save_obj(obj, name ):
    with open('web/'+ name, 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

def save_model(model, model_filepath):
    """
    Export your model as a pickle file.
    Saves trained model as pickle file to be loaded later.
    
    """ 
    filename = model_filepath
    pickle.dump(model, open(filename, 'wb'))

def getDriverConfidenceDict(data):
    dnf_by_driver = data.groupby('driver').sum()['driver_dnf']
    driver_race_entered = data.groupby('driver').count()['driver_dnf']
    driver_dnf_ratio = (dnf_by_driver/driver_race_entered)
    driver_confidence = 1-driver_dnf_ratio
    driver_confidence_dict = dict(zip(driver_confidence.index,driver_confidence))
    return driver_confidence_dict

def getConstructorReliabilityDict(data):
    dnf_by_constructor = data.groupby('constructor').sum()['constructor_dnf']
    constructor_race_entered = data.groupby('constructor').count()['constructor_dnf']
    constructor_dnf_ratio = (dnf_by_constructor/constructor_race_entered)
    constructor_reliability = 1-constructor_dnf_ratio
    constructor_reliability_dict = dict(zip(constructor_reliability.index,constructor_reliability))
    return constructor_reliability_dict


def prepareDataset(data, driver_confidence_dict, constructor_reliability_dict):
    data['driver_confidence'] = data['driver'].apply(lambda x:driver_confidence_dict[x])
    data['constructor_reliability'] = data['constructor'].apply(lambda x:constructor_reliability_dict[x])
    #removing retired drivers and constructors
    active_constructors = ['Alpine F1', 'Williams', 'McLaren', 'Ferrari', 'Mercedes',
                        'AlphaTauri', 'Aston Martin', 'Alfa Romeo', 'Red Bull',
                        'Haas F1 Team']
    active_drivers = ['Daniel Ricciardo', 'Mick Schumacher', 'Carlos Sainz',
                    'Valtteri Bottas', 'Lance Stroll', 'George Russell',
                    'Lando Norris', 'Sebastian Vettel', 'Kimi Räikkönen',
                    'Charles Leclerc', 'Lewis Hamilton', 'Yuki Tsunoda',
                    'Max Verstappen', 'Pierre Gasly', 'Fernando Alonso',
                    'Sergio Pérez', 'Esteban Ocon', 'Antonio Giovinazzi',
                    'Nikita Mazepin','Nicholas Latifi']
    data['active_driver'] = data['driver'].apply(lambda x: int(x in active_drivers))
    data['active_constructor'] = data['constructor'].apply(lambda x: int(x in active_constructors))
    return data

def saveCleanedData(data):
    global data_path
    # Generate new dataset for predictor
    cleaned_data = data[['GP_name','quali_pos','constructor','driver','position','driver_confidence','constructor_reliability','active_driver','active_constructor']]
    cleaned_data = cleaned_data[(cleaned_data['active_driver']==1)&(cleaned_data['active_constructor']==1)]
    #
    fullname = os.path.join(data_path, 'cleaned_data.csv')
    cleaned_data.to_csv(fullname,index=False)
    return cleaned_data


def saveDriverConfidenceDict(driver_confidence_dict):
    driver_confidence_dict_str = {}
    for key , value in driver_confidence_dict.items():
        # Correct for New Drivers
        if value == 1.0:
            value = 0.10
        driver_confidence_dict_str[key] = np. array([value])
        #print ("%s: %s" % (key, value))
        
    save_obj(driver_confidence_dict_str, 'driver_dict' )

def saveConstructorReliabilityDict(constructor_reliability_dict):
    constructor_reliability_dict_str = {}
    for key , value in constructor_reliability_dict.items():
        # Correct value 
        constructor_reliability_dict_str[key] = np. array([value])
        #print ("%s: %s" % (key, value))
        
    save_obj(constructor_reliability_dict_str, 'constructor_dict' )

def checkProbability(data2021):
    global data_path
    data2021=data2021.sort_values(by='date')
    races = data2021['GP_name'].unique().tolist()
    drivers = data2021['driver'].unique().tolist()
    constructors = data2021['constructor'].unique().tolist()
    results = {'race': [],
          'driver':[],
          'constructor':[],
          'points':[]}
    for race in races:
        for driver in drivers:
            clst = data2021.loc[(data2021['GP_name']==race)&(data2021['driver']==driver)]['constructor'].unique().tolist()
            plst = data2021.loc[(data2021['GP_name']==race)&(data2021['driver']==driver)]['points'].unique().tolist()
            for c in clst:
                for p in plst:
                    results['race'].append(race)
                    results['driver'].append(driver)
                    results['constructor'].append(c)
                    results['points'].append(p)
    df2021= pd.DataFrame(results)
    pts_by_driver = df2021.groupby('driver').sum()['points']
    driver_race = df2021.groupby('driver').count()['race']
    driver_points_ratio = (pts_by_driver/len(races)/25.0)
    driver_points_dict = dict(zip(driver_points_ratio.index,driver_points_ratio))
    pts_by_constructor = df2021.groupby('constructor').sum()['points']
    constructor_race = df2021.groupby('constructor').count()['race']
    constructor_pts_ratio = (pts_by_constructor/len(races)/(25.0+18.0))
    constructor_points_dict = dict(zip(constructor_pts_ratio.index,constructor_pts_ratio))
    #constructor_points_dict = dict(zip(pts_by_constructor.index,pts_by_constructor))
    driver_pred_dict_str = {}
    for key , value in driver_points_dict.items():
        driver_pred_dict_str[key] = np. array([value])
        #print ("%s: %s" % (key, value))
    save_obj(driver_pred_dict_str, 'driver_pred_dict' )
    constructor_pred_dict_str = {}
    for key , value in constructor_points_dict.items():
        constructor_pred_dict_str[key] = np. array([value])
        #print ("%s: %s" % (key, value))
    save_obj(constructor_pred_dict_str, 'constructor_pred_dict' )
    qualif = {'race': [],
          'driver':[],
          'quali_pos':[]
         }
    for race in races:
        for driver in drivers:
            qlst = data2021.loc[(data2021['GP_name']==race)&(data2021['driver']==driver)]['quali_pos'].unique().tolist()
            for q in qlst:
                qualif['race'].append(race)
                qualif['driver'].append(driver)
                qualif['quali_pos'].append(q)
    qualif2021= pd.DataFrame(qualif)
    fullname = os.path.join(data_path, 'qualif_filtered.csv')
    qualif2021.to_csv(fullname, index = False)
    # last race
    last_race = races[len(races)-1]
    qualif_last= qualif2021[qualif2021['race']==last_race]
    fullname = os.path.join(data_path, 'qualif_lastrace.csv')
    qualif_last.to_csv(fullname, index = False)

def generateModels(data):
    n_estimators = [int(x) for x in np.linspace(start=200,stop=2000,num=10)]
    max_features = ['auto','sqrt']
    max_depth = [int(x) for x in np.linspace(10,110,num=11)]
    min_samples_split = [2,5,8,10,15,20]
    min_samples_leaf = [1,2,4,6,8,10]
    bootstrap = [True,False]

    random_parms = {
        'n_estimators':n_estimators,
        'max_features':max_features,
        'max_depth':max_depth,
        'min_samples_split':min_samples_split,
        'min_samples_leaf':min_samples_leaf,
        'bootstrap':bootstrap
                    }

    x = data[['GP_name','quali_pos','constructor','driver','position','driver_confidence','constructor_reliability','active_driver','active_constructor']]
    x = x[x['active_constructor']==1]
    x = x[x['active_driver']==1]
    sc  = StandardScaler()
    le = LabelEncoder()
    x['GP_name'] = le.fit_transform(x['GP_name'])
    x['constructor'] = le.fit_transform(x['constructor'])
    x['driver'] = le.fit_transform(x['driver'])
    x['GP_name'] = le.fit_transform(x['GP_name'])
    X = x.drop(['position','active_driver','active_constructor'],1)
    y = x['position'].apply(lambda x: position_index(x))
    #
    rf_rand = RandomForestClassifier()
    #rf_random = RandomizedSearchCV(estimator=rf_rand,param_distributions=random_parms,n_iter=100,cv=10,verbose=2,n_jobs=-1)
    rf_random = RandomizedSearchCV(estimator=rf_rand,param_distributions=random_parms,n_iter=100,cv=10,verbose=0,n_jobs=-1)
    rf_random.fit(X,y)
    rf_random.best_params_
    #
    rf = RandomForestClassifier(n_estimators=100,min_samples_split=20,min_samples_leaf=1,max_features='sqrt',max_depth=90,bootstrap=True)
    kf = StratifiedKFold(n_splits=10,random_state=None,shuffle=False)
    for train_index,test_index in kf.split(X,y):
        X_train,X_test = X.iloc[train_index],X.iloc[test_index]
        y_train,y_test = y.iloc[train_index],y.iloc[test_index]
    #    
    rf.fit(X_train,y_train)
    y_pred_rf = rf.predict(X_test)
    cnf_mat_rf = confusion_matrix(y_test,y_pred_rf)
    cnf_mat_rf = cnf_mat_rf/cnf_mat_rf.sum()
    #
    model_filepath='./models/{}.pkl'.format('RandomForestClassifier')
    print('Saving model ...\n    MODEL: {}'.format(model_filepath))
    save_model(rf, model_filepath)




def main():
    global data_path
    # args is a list of the command line args
    args = sys.argv[1:]
    # 1. Check for the arg pattern:
    if len(args) >= 1:
        data_path = args[0]
    else:
        data_path = './data_f1'
    # Check Directory exists
    if not os.path.exists(data_path):
        os.mkdir(data_path)
    # check models directory exists
    if not os.path.exists('./models'):
        os.mkdir('./models')
    # check web directory exists
    if not os.path.exists('./web'):
        os.mkdir('./web')
    init_time2 = datetime.datetime.now()
    #
    fullname = os.path.join(data_path, 'data_filtered.csv') 
    data = pd.read_csv(fullname)
    #
    fullname = os.path.join(data_path, 'data_filtered_2021.csv')
    data2021 = pd.read_csv(fullname)
    #
    driver_confidence_dict=getDriverConfidenceDict(data)
    constructor_reliability_dict=getConstructorReliabilityDict(data)
    data=prepareDataset(data, driver_confidence_dict, constructor_reliability_dict)
    cleaned_data=saveCleanedData(data)
    # parallel
    # Execute Threads
    t3 = Thread(target=saveDriverConfidenceDict, args=(driver_confidence_dict,))
    t4 = Thread(target=saveConstructorReliabilityDict, args=(constructor_reliability_dict,))
    t5 = Thread(target=generateModels, args=(cleaned_data,))
    t6 = Thread(target=checkProbability, args=(data2021,))

    t3.start()
    t4.start()
    t5.start()
    t6.start()

    t3.join()
    t4.join()
    t5.join()
    t6.join()
    #
    #
    end_time2 = datetime.datetime.now()
    dif_time2=end_time2-init_time2
    #
    temp=dif_time2.seconds
    hours = temp//3600
    temp = temp - 3600*hours
    minutes = temp//60
    seconds = temp - 60*minutes
    print('Execution Time for HOL1 generate models: %d hour:%d min:%d sec' %(hours,minutes,seconds))


if __name__ == "__main__":
    main()
