
contacts = {
    'Number': 4,
    'Students':
    [
        {'name': 'Ram', 'Email':'Ram@example.com'},
        {'name': 'Mohan', 'Email':'Mohan@example.com'},
        {'name': 'Ravi', 'Email':'Ravi@example.com'},
        {'name': 'Joy', 'Email':'Joy@example.com'}
    ]
}

print(contacts['Students'])

for student  in contacts['Students']:
    print(student['Email'])
