% user_id/time/ecg[ ]
user_id = 3;
URL = ['https://nestjs-server-dot-ecgproject-1069.appspot.com/users/',num2str(user_id),'/ecgdata12'];
% URL = 'http://localhost:3000/ecgdata';
options = weboptions('MediaType','application/json');
t = datetime('now','InputFormat','dd-MMM-yyyy HH:mm:ss:sss');
t.TimeZone = 'Asia/Taipei';
timestart = posixtime(t)*1000 ;
Sample_rate  = 256;
for i = 1:1:30
    time =[timestart-1000 : 1000/(Sample_rate-1) : timestart];
    time = time';
    ecg = [];
    for j=1:1:12
        ecg =[ecg; sin([-pi:(2*pi/(Sample_rate-1)):pi])*(mod(i,3)+1)];
    end
    ecg =ecg';
    jsondata = jsonencode(table(time,ecg));
    response = webwrite(URL,jsondata,options);
    timestart  = timestart+1000
end