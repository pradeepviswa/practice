# clean up folder
# move files
    # from C:\Temp\Python-3
    # to C:\Temp\Python-3-backup

import os

# create folder
os.mkdir("C:\Temp\Python-3-backup")


# list all filders and directories inside folder
folder = "C:\Temp\Python-3"
entries = os.scandir(folder)
for entry in entries:
    print(entry.name)
    
# chck if entry is file or directory
folder = "C:\Temp\Python-3"
entries = os.scandir(folder)
for entry in entries:
    if os.path.isfile(entry):
        print('File:', entry.name)
    elif os.path.isdir(entry):
        print('Directory:', entry.name)

# move a file. rename allows to rename as well as move a file from source to destination
folder_original = 'C:\Temp\Python-3'
folder_destination = 'C:\Temp\Python-3-backup'

location_original = os.path.join(folder_original, 'new.txt')
locaion_destination = os.path.join(folder_destination, 'new.txt')

os.rename(location_original, locaion_destination)