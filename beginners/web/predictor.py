from pickle import load
import pandas as pd
import pickle
from sklearn.preprocessing import LabelEncoder

# Dictionnary used by ML Model hypothesis
driver_dict = pickle.load(open('./driver_dict','rb'))
constructor_dict = pickle.load(open('./constructor_dict','rb'))

# Predictions after each race
driver_pred_dict = pickle.load(open('./driver_pred_dict','rb'))
constructor_pred_dict = pickle.load(open('./constructor_pred_dict','rb'))

# Dataset generated in previous phase
data = pd.read_csv('../data_f1/cleaned_data.csv')

qualif = pd.read_csv('../data_f1/qualif_filtered.csv')
lastqualif = pd.read_csv('../data_f1/qualif_lastrace.csv')

# Model loaded
clf = pickle.load(open('./RandomForestClassifier.pkl','rb'))
y_dict = {1:'Podium Finish',
          2:'Points Finish',
          3:'No Points Finish'        
        }

le_d = LabelEncoder()
le_d.fit(data[['driver']])
le_c = LabelEncoder()
le_c.fit(data[['constructor']])
le_gp = LabelEncoder()
le_gp.fit(data[['GP_name']])

def pred(driver,constructor,quali,circuit):
    gp = le_gp.fit_transform([circuit]).max()
    quali_pos = quali
    constructor_enc = le_c.transform([constructor]).max()
    driver_enc = le_d.transform([driver]).max()
    driver_confidence = driver_dict[driver].max()
    constructor_reliability = constructor_dict[constructor].max()
    prediction = clf.predict([[gp,quali_pos,constructor_enc,driver_enc,driver_confidence,constructor_reliability]]).max()
    #print(clf.predict([[gp,quali_pos,constructor_enc,driver_enc,driver_confidence,constructor_reliability]]))
    #return y_dict[prediction]
    return prediction, driver_confidence, constructor_reliability


def getproba(driver,constructor):
    driver_proba = driver_pred_dict[driver].max()
    constructor_proba = constructor_pred_dict[constructor].max()
    return driver_proba, constructor_proba

def getQualifData(circuit, driver):
    df = qualif[(qualif['race']==circuit) & (qualif['driver']==driver)]
    qlst = df['quali_pos'].tolist()
    if len(qlst) > 0:
        return qlst[0]
    else :
        df = lastqualif[(qualif['driver']==driver)]
        qlst = df['quali_pos'].tolist()
        return qlst[0]
