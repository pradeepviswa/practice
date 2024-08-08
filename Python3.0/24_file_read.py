#lookup = input('Which softwware actomym you want to look for?\n')
lookup = 'IaaS'

found = False

with open('input.txt') as file:

    for line in file:        
        print(line)
        if lookup in line:
            print('Acronym of', lookup, 'found in line:', line)
            found = True
            break

if not found:
    print('Acronym not found with keyword: ', lookup)