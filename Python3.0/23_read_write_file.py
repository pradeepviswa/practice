# how to open a file
# absolute path = c:\temp\input.txt
# relative path = .\input.txt

#open funciton
file = open('input.txt')
try:
    pass
finally:
    file.close()


# with 'with' keyword, read entire file as a string
with open('input.txt') as file:
    result = file.read()
    print(result)

# with 'with' keyword, read each line separately
with open('input.txt') as file:
    for line in file:
        print(line)

#check for value
with open('input.txt') as file:
    for line in file:
        if "Iaas" in line:
            print('Found IaaS :',line)

