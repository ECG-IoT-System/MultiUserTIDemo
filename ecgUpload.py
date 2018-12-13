import json
import grequests
import requests
import os 
import time



folder = 'ecg_json'
url ="https://nestjs-server-dot-ecgproject-1069.appspot.com/ecgdata"
##url="https://5c630000.ngrok.io/ecgdata"
uploadLength = 3


while(1):
    dirs = os.listdir(folder)
    if len(dirs) > uploadLength:
        dirs = dirs[0:uploadLength]
    jsonArray = []
    currentFiles = []
    for file in dirs:
        if file.endswith(".json"):
            file_directory = folder + '/' + file
            currentFiles.append(file_directory)
            with open(file_directory) as f:
                ecgdataJson = json.load(f)
                jsonArray.append(ecgdataJson)

    t1 = time.time()
    print(len(jsonArray))
    tasks = [grequests.post(url, data = ecg )  for ecg in jsonArray ]
    responses_list  = grequests.map(tasks)
    t2 = time.time()
    print(responses_list)
    print('grequest method', t2 - t1)
    
    for filename in currentFiles :
        if os.path.exists(filename):
            os.remove(filename)
        else:
          print("The file does not exist")
        
    del currentFiles[:] 


    
    






