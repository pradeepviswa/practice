acronym = ['LOL','BRB']
acronym.append('TBD')
acronym.append('BTB')
print(acronym)

for x in acronym:
    print (x)

acronym.remove('BTB')
print(acronym)
del acronym[2]
print(acronym)