# pip install requests 
import requests

people = requests.get('http://api.open-notify.org/astros.json')

json = people.json()

print(json)

print('People curently in spaceare:')

for p in json['people']:
    print(p['name'])
