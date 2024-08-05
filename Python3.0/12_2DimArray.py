menus = { 'Breakfast': ['Egg Sandwich','Bagel','Coffee'],
          'Lunch': ['Rice', 'Biryani', 'Thali'],
          'Dinner': ['Salad', 'Bread', 'Tea']
         }
print('Breakfast:\t', menus['Breakfast'])
print('Lunch:\t', menus['Lunch'])
print('Dinner:\t', menus['Dinner'])


#loop, this wil print only key
for key in menus:
    print(key)


#print key and value both using for loop
for name, menu in menus.items():
    print(name, ":", menu)


#dict to represent objects

person = {'Name': 'Smith',
        'Age': '30 years',
        'City': 'New York'}

print('Name is', person.get('Name'), 'Age is', person.get('Age'), 'City is', person.get('City'))



