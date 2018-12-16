clear;

% mac/time/ecg/gsensor/rssi
macTable = ["a0e6f8fefc6b","cc78abad400b","cc78abad2356"];
URL = 'https://nestjs-server-dot-ecgproject-1069.appspot.com/ecgdata';
% URL = 'http://localhost:3000/ecgdata';
options = weboptions('MediaType','application/json');
t = datetime('now','InputFormat','dd-MMM-yyyy HH:mm:ss:sss');
t.TimeZone = 'Asia/Taipei';
timestart = posixtime(t)*1000;
for i = 1:1:100
    
    data = sin([-pi:(2*pi/255):pi])*(mod(i,3)*0.5+1);
    gsensor = sin([-pi:(2*pi/9):pi]);
    rssi = 0;
    for j =1:1:3
        time = [timestart-1000, timestart+j];
        mac = macTable(j);
%         jsondata = jsonencode(table(mac,time,data,gsensor,rssi));
        jsondata = jsonencode(table(mac,time,data,gsensor));
        t = tic;
        response = webwrite(URL,jsondata(2:end-1),options);
        toc(t);
    end
    timestart  = timestart+1000
end