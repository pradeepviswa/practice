import os
import shutil

# path of the deskto folder
#desktop_path = os.path.expanduser("~/Desktop")
desktop_path = "C:\\Users\\prade\\OneDrive\\Desktop"
print('Desktop Folder:', desktop_path)

# dictionary co ntaining the folder names and their coresponding files an extensions
folder = {
    'Images': ['.jpeg','.jpg','.png','.gif'],
    'Documents': ['.doc','.docx','.pdf','.txt'],
    'Archives': ['.zip','.rar']
}

#create subfolders if they don't exists
for folder_name in folder:
    #print(folder_name)
    folder_path = os.path.join(desktop_path, folder_name)
    print(folder_path)
    if not os.path.exists(folder_path):
        os.mkdir(folder_path)

# move files to the destination folder
for file_name in os.listdir(desktop_path):
    #print('File name:', file_name)
    original_file_path = os.path.join(desktop_path,file_name)
    if os.path.isfile(original_file_path):
        # print(original_file_path)
        for folder_name, extensions in folder.items():
            for extension in extensions:
                if file_name.endswith(extension):
                    destination_folder = os.path.join(desktop_path,folder_name)
                    print(original_file_path, destination_folder)
                    #shutil.move(original_file_path,destination_folder)