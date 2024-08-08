import os

original_folder = "C:\Temp\Python-3"
destination_folder = "C:\Temp\Python-3-backup"

if not os.path.exists(destination_folder):
    os.mkdir(destination_folder)
else:
    print('Destination path already exists:', destination_folder)

entries = os.scandir(original_folder)

for entry in entries:
    if os.path.isfile(entry):
        fname = entry.name
        location_original = os.path.join(original_folder, fname)
        location_destination = os.path.join(destination_folder, fname)
        print(location_original,' - ', location_destination)
        os.rename(location_original, location_destination)
        