# Ask user what acronym they want to add
acronym = input('What acronym you want to add?\n')
# Then ask the user for teh definition
definition = input('Enter definition:\n')
# Open the file
    # open('filename','w',encoding="utf-8")
    # mode can be
        # w = write
        # r = read
        # a = append
        # r+ = readn and write
with open('input.txt', 'a') as file:
    # Write the new acronym and definition tot he file
    file.write(acronym + ' - ' + definition + '\n')