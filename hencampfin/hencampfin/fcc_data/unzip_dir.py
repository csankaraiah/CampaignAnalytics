import os, zipfile

src_dir_name = '/Users/demo/Documents/learn/pracpy/chscrapy/fcc_data/oppexp/full'
tgt_dir_name = '/Users/demo/Documents/learn/pracpy/chscrapy/fcc_data/oppexpunzip'
extension = ".zip"
count = 5
os.chdir(src_dir_name) # change directory from working dir to dir with files

for item in os.listdir(src_dir_name): # loop through items in dir
    if item.endswith(extension): # check for ".zip" extension
        #print(item)
        file_name = src_dir_name + "/" + item # get full path of files
        zip_ref = zipfile.ZipFile(file_name, 'r') # create zipfile object
        count += 1
        zip_ref.extractall(tgt_dir_name) # extract file to dir
        old_file = os.path.join(tgt_dir_name, 'oppexp.txt')
        new_file = os.path.join(tgt_dir_name, 'oppexp' + str(count) + '.txt')
        os.rename(old_file, new_file)
        zip_ref.close() # close file
        # #os.remove(file_name) # delete zipped file