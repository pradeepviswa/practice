#register here
#https://www.weatherapi.com/
#API token/key
# 0d8fe481e0d4432b995181308240508

#api call
#http://api.weatherapi.com/v1/current.json?key=0d8fe481e0d4432b995181308240508&q=India&aqi=no

import requests

city = "pune"
response = requests.get('http://api.weatherapi.com/v1/current.json?key=0d8fe481e0d4432b995181308240508&q='+city+'&aqi=no')
json = response.json()
print(json)

location = json.get('location').get('name')
localtime = json.get('location').get('localtime')
temprature = json.get('current').get('temp_c')
condition = json.get('current').get('condition').get('text')

print('Location:', location)
print('Location:', localtime)
print('Temprature:', temprature, 'c')
print('Condition:', condition)

print("Today's weather in", location, "is", temprature, "degree celcius and is", condition )

