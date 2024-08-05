acromym = {'LOL':'Laugh out loud',
           'IDK': "I don't know",
           'TBH': 'tob e honest'
           }

#print dict
print(acromym)

#search for value
print(acromym['LOL'])


#empty dictionary
acromym =  {}
acromym['LOL'] = "Lauch out Loud"
acromym['IDK'] = "I don't know"
acromym['TBH'] = "to be honest"

print(acromym['LOL'])

acromym['LOL'] = "don't laugh"
print(acromym['LOL'])


#delele a vlue
del acromym['LOL']
print(acromym)


#gettign an item tha's NOT int he dictionary
acromym = {'LOL':'Laugh out loud',
           'IDK': "I don't know",
           'TBH': 'to be honest'
           }
definition = acromym.get('BTW')
if definition:
    print(definition)
else:
    print("Key doesn't exists")


#usign disc to translate sentence
sentence = 'IDK what happened TBH'
translate = acromym.get('IDK') + ' what happended ' + acromym.get('TBH')
print(sentence)
print(translate)