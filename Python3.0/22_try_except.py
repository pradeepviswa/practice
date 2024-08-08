acronyms = {
    'LOL': 'laugh out loud',
    'IDK': "I don't know",
    'TBH': 'to be honest'
}
try:
    definition = acronyms['BTW']
    print(definition)
except:
    print('The key does not exists')
finally:
    print('The acronyms we have defined are:')
    for i in acronyms:
        print(i)

        