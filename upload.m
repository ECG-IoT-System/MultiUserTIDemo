clear all;
clc;
emptyCount  = 0;
while(1)
    
    info = dir('ecg_json/*.json');
    file_dir = 'ecg_json/';
    if length(info) > 0
        for i = 1 : length(info)
            jsonName = info(i).name;
            fid = fopen([file_dir jsonName]);
            raw = fread(fid,inf);
            str = char(raw');
            fclose(fid);
            jsonFile = jsondecode(str);
            
            t2 = tic;
            url = "https://nestjs-server-dot-ecgproject-1069.appspot.com/ecgdata";
%             url="https://5c630000.ngrok.io/ecgdata";
            options = weboptions('MediaType','application/json','Timeout',20);
            
            response = webwrite(url,jsonFile,options);
            toc(t2);
            
            if response.statusCode == 200
                delete([file_dir jsonName]);
            else
                disp('error')
                disp(response.message)
            end
        end
        
    else
        disp("No ECG json file");
        emptyCount = emptyCount + 1 ;
        if emptyCount > 1000
            disp("Break upload");
            break;
        end
    end
    
end
