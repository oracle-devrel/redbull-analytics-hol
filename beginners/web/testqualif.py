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

    
qualif = []
for row in active_drivers:
    #for elem in row:
    circuit = "Silverstone Circuit"
    #circuit = "Yas Marina Circuit"
    driver = row[0]
    q =  predictor.getQualifData(circuit, driver)
    qualif.append(q)

print(qualif)
    
