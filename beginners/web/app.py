from flask import Flask,render_template,request, url_for,send_from_directory
import predictor
import pandas as pd 

app = Flask(__name__)

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


@app.route("/images/<path:path>")
def static_dir(path):
    return send_from_directory("images", path)

@app.route('/')
def get_input():
    return render_template('index.html')

@app.route('/predict',methods=['POST'])
def predict_position():
    circuit = request.form['circuit']
    weather = request.form['weather']

    #res = predictor.pred(circuit, weather)
    res = []
    for row in active_drivers:
        #for elem in row:
        driver = row[0]
        constructor = row[1]
        quali = predictor.getQualifData(circuit, driver)
        my_rangeprediction, driver_confidence, constructor_reliability = predictor.pred(driver,constructor,quali,circuit)
        #print ("%s: %s : %s : %s : %s " % (driver, constructor, my_rangeprediction, driver_confidence, constructor_reliability))
        driverproba, constructorproba = predictor.getproba(driver,constructor)
        predpercentage = "{:.2%}".format(driverproba)
        elem = [driver, constructor, my_rangeprediction, driver_confidence, constructor_reliability, predpercentage]
        res.append(elem)
    
    #print (res)
    df = pd.DataFrame(res, columns = ['Driver','Constructor','podium', 'driver_confidence', 'constructor_reliability', 'Prediction'] )
    # Filter only Drivers with Podium probability
    df1 = df[df['podium']==1]
    df1 = df1.sort_values(['Prediction'], ascending=False).head(5)
    if len(df1) < 5 :
        df2 = df[df['podium']==2]
        df2 = df2.sort_values(['Prediction'], ascending=False).head(5-len(df1))
        df1 = df1.append(df2)
    df1 = df1.drop(['Constructor', 'Prediction'],1)
    
    return render_template('index.html',tables=[df1.to_html(classes='driver')])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8443, debug=True, ssl_context='adhoc')


