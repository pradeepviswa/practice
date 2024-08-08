
def find_acronym():
    lookup = input('Which acronym you want to look for?\n')
    found = False

    try:       
        with open('input.txt') as file:
            for line in file:
                if lookup in line:
                    print(line)
                    found = True
                    break
    except FileNotFoundError as e:
        print('File not found')
        return

    if not found:
        print(lookup,'acronym not found.')
        
    

def add_acronym():
    acronym = input('What acronym you want to add?\n')
    definition = input('Definition \n')

    with open('input.txt','a') as file:
        file.write(acronym +' - '+ definition)

def main():
    choice = input("To find an acronym type 'F', to add an acromym type 'A'\n")
    if choice == 'F':
        find_acronym()
    elif choice == 'A':
        add_acronym()
    else:
        print('Invalid choice.')
         

main()