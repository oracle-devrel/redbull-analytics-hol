import predictor
import pandas as pd

active_drivers = [['Daniel Ricciardo','McLaren'], 
                  ['Mick Schumacher','Haas F1 Team'], 
                  ['Carlos Sainz','Ferrari'],
                  ['Valtteri Bottas','Mercedes'], 
                  ['Lance Stroll','Aston Martin'], 
                  ['George Russell','Williams'],
                  ['Lando Norris','McLaren'], 
                  ['Sebastian Vettel','Aston Martin'], 
                  ['Kimi Räikkönen','Alfa Romeo'],
                  ['Charles Leclerc','Ferrari'], 
                  ['Lewis Hamilton','Mercedes'], 
                  ['Yuki Tsunoda','AlphaTauri'],
                  ['Max Verstappen','Red Bull'], 
                  ['Pierre Gasly','AlphaTauri'], 
                  ['Fernando Alonso','Alpine F1'],
                  ['Sergio Pérez','Red Bull'], 
                  ['Esteban Ocon','Alpine F1'], 
                  ['Antonio Giovinazzi','Alfa Romeo'],
                  ['Nikita Mazepin','Haas F1 Team'],
                  ['Nicholas Latifi','Williams']]

        
#active_drivers.head()
res = []
for row in active_drivers:
    #for elem in row:
    circuit = "Silverstone Circuit"
    driver = row[0]
    constructor = row[1]
    quali =  predictor.getQualifData(circuit, driver)
    my_rangeprediction, driver_confidence, constructor_reliability = predictor.pred(driver,constructor,quali,circuit)
    #predpercentage = "{:.2%}".format(constructor_reliability*driver_confidence)
    #predpercentage = "{:.2%}".format(constructor_reliability)
    driverproba, constructorproba = predictor.getproba(driver,constructor)
    predpercentage = "{:.2%}".format(driverproba)
    # print ("%s: %s : %s : %s : %s : %s " % (driver, constructor, my_rangeprediction, driver_confidence, constructor_reliability, predpercentage))
    elem = [driver, constructor, my_rangeprediction, driver_confidence, constructor_reliability, predpercentage]
    res.append(elem)

print(res)

# pandas analysis    

df = pd.DataFrame(res, columns = ['Driver','Constructor','podium', 'driver_confidence', 'constructor_reliability', 'Prediction'])
# Filter only Drivers with Podium probability
df1 = df[df['podium']==1]
print(df1)
print(len(df1))
df1 = df1.sort_values(['Prediction'], ascending=False).head(5)
#df = df.sort_values(['Prediction'], ascending=False).head(5)
#df=df.drop(['Constructor','podium','driver_confidence', 'constructor_reliablity'],1)
print(df1)    
if len(df1) < 5 :
    df2 = df[df['podium']==2]
    df2 = df2.sort_values(['Prediction'], ascending=False).head(5-len(df1))
    print(df2)
    df1 = df1.append(df2)

df1 = df1.drop(['Constructor'],1)

print(df1) 
