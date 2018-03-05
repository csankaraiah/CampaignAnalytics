import csv

with open("/Users/demo/Documents/BirchooLLC/Source_Files/Fed_Fin/Src_Files/cm.txt", "r") as file_pipe:
    reader_pipe = csv.reader(file_pipe, delimiter='|')
    with open("/Users/demo/Documents/BirchooLLC/Source_Files/Fed_Fin/Src_Files/cm.csv", 'w') as file_comma:
        writer_comma = csv.writer(file_comma, delimiter=',')
        writer_comma.writerows(reader_pipe)