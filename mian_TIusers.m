if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

if exist('s','var')
    %     fclose(s);
    delete(s);
    clear s;
    clear all;
end
clc;
clear all;
close all;

device_num =3;
%-------- setting ---------------%
FIRflag=1; % 1 => enabling FIR
%-------- setting ---------------%


%%%%% Change the serial Port number %%%%%%
% s = serial('/dev/tty.usbserial-06EB12212EA31');
s = serial('COM4');
%%%%% Change the serial Port number %%%%%%
s.BaudRate = 115200;
s.Tag = 'My serial object';
% s.InputBufferSize=2048*50;
s.InputBufferSize=550*100;

fopen(s);


choice = menu2('GateWay Option',' Sync Scan Connect','Read Data');
if choice == 1
    
    % ------------   send sync command
    fwrite(s,1,'uint8');
    c = clock;
    c(7) = fix(1000*(c(6)-fix(c(6)))/256);
    c(8) = mod(1000*(c(6)-fix(c(6))),256);
    c(6) = fix(c(6));
    %send time
    
    fwrite(s,c,'uint8');
    back_time  = fread(s,8,'uint8')';
    if back_time(1) == 0
        out = ['Sync Done! ' num2str(back_time(4)) ':' num2str(back_time(5)) ':' num2str(back_time(6))];
        disp(out)
    end
    
    while back_time(1) ~= 0
        pause(2);
        fwrite(s,1,'uint8');
        c = clock;
        c(7) = fix(1000*(c(6)-fix(c(6)))/256);
        c(8) = mod(1000*(c(6)-fix(c(6))),256);
        c(6) = fix(c(6));
        %send time
        fwrite(s,c,'uint8');
        back_time  = fread(s,8,'uint8')'
    end
    %------------  send sync command
    
    %------------------scan --------- %
    
    fwrite(s,2,'uint8');
    device_num = fread(s,1,'uint8');
    disp(['device_num : ',num2str(device_num) ]);
    macTable = [];
    for i=1:1:device_num
        mac = fread(s,6,'uint8');
        tmp = [ dec2hex(mac(1)) dec2hex(mac(2)) dec2hex(mac(3)) dec2hex(mac(4)) dec2hex(mac(5)) dec2hex(mac(6)) ];
        macTable =[ macTable; tmp ];
    end
    
    
    while device_num ~= 3
        disp(['device_num : ',num2str(device_num) ]);
        pause(2);
        fwrite(s,2,'uint8');
        device_num = fread(s,1,'uint8');
        for i=1:1:device_num
%             macTable =[ macTable; reshape(dec2hex(fread(s,6,'uint8')),[1 12])];
            disp([num2str(fread(s,6,'uint8')')]);
        end
    end
    
    
    %------------------scan --------- %
    
    %-------- connect ---------------%
    fwrite(s,3,'uint8');
    macTable = [];
    for i=1:1:device_num
        mac = fread(s,6,'uint8');
        tmp = [ dec2hex(mac(1)) dec2hex(mac(2)) dec2hex(mac(3)) dec2hex(mac(4)) dec2hex(mac(5)) dec2hex(mac(6)) ];
        macTable =[ macTable; tmp ];
        %             disp([num2str(fread(s,6,'uint8')')]);
    end
    %-------- connect ---------------%

    
end



t2 = datetime('today','Inputformat','dd-MM-yyyy');
t2.TimeZone = 'Asia/Taipei';
timestart2 = posixtime(t2)*1000;

FIR=[-0.00611779802346922,-0.00625504233834900,-0.00639124756152272,-0.00652632292468917,-0.00666017805064469,-0.00679272303124695,-0.00692386850516743,-0.00705352573535570,-0.00718160668613947,-0.00730802409988414,-0.00743269157313628,-0.00755552363217547,-0.00767643580789987,-0.00779534470997097,-0.00791216810014414,-0.00802682496471177,-0.00813923558598708,-0.00824932161275723,-0.00835700612963550,-0.00846221372524318,-0.00856487055915309,-0.00866490442752768,-0.00876224482738604,-0.00885682301943527,-0.00894857208940331,-0.00903742700781158,-0.00912332468812740,-0.00920620404323762,-0.00928600604018690,-0.00936267375312517,-0.00943615241441123,-0.00950638946382088,-0.00957333459580983,-0.00963693980478395,-0.00969715942833094,-0.00975395018836987,-0.00980727123017687,-0.00985708415924788,-0.00990335307596067,-0.00994604460800137,-0.00998512794052290,-0.0100205748440041,-0.0100523596997823,-0.0100804595232325,-0.0101048539845701,-0.0101255254272568,-0.0101424588839894,-0.0101556420902573,-0.0101650654954525,-0.0101707222715238,0.989827391680836,-0.0101707222715238,-0.0101650654954525,-0.0101556420902573,-0.0101424588839894,-0.0101255254272568,-0.0101048539845701,-0.0100804595232325,-0.0100523596997823,-0.0100205748440041,-0.00998512794052290,-0.00994604460800137,-0.00990335307596067,-0.00985708415924788,-0.00980727123017687,-0.00975395018836987,-0.00969715942833094,-0.00963693980478395,-0.00957333459580983,-0.00950638946382088,-0.00943615241441123,-0.00936267375312517,-0.00928600604018690,-0.00920620404323762,-0.00912332468812740,-0.00903742700781158,-0.00894857208940331,-0.00885682301943527,-0.00876224482738604,-0.00866490442752768,-0.00856487055915309,-0.00846221372524318,-0.00835700612963550,-0.00824932161275723,-0.00813923558598708,-0.00802682496471177,-0.00791216810014414,-0.00779534470997097,-0.00767643580789987,-0.00755552363217547,-0.00743269157313628,-0.00730802409988414,-0.00718160668613947,-0.00705352573535570,-0.00692386850516743,-0.00679272303124695,-0.00666017805064469,-0.00652632292468917,-0.00639124756152272,-0.00625504233834900,-0.00611779802346922];


index = zeros(device_num,1)+ -1;
tLast = zeros(device_num,1);
packetCount = zeros(1,device_num);

%initial valuses for packet indices, ranging from 0-255, each packet has 550 bytes
PacketNum=0; %num of packets, each second should receive 3 packets, each packet for data of one lead

collectSeconds = 120;
appendData = zeros(device_num,collectSeconds*256);
appendTime = zeros(device_num,collectSeconds*256);
appendPacketTime = zeros(device_num,collectSeconds);



CombPack  = fread(s,550,'uint8');
while(isempty(CombPack))
    CombPack  = fread(s,550,'uint8');
end
flag = 0;

disp("start clooecting");
while (1)
% for packIdx = 1 : collectSeconds*3
    
    if flag == 0
        flag =1;
    else
        CombPack  = fread(s,550,'uint8');
    end
    CombPack = (CombPack.');
    %CombPack(1:7)
    %PacketBuff(PacketNum,1:550) = CombPack(1,1:550);                         %組合實際要傳的550bytes
    %1~8為header
    %1:Node number
    %2:index(0~255)
    %3:hour
    %4:minute
    %5:second
    %6,7:mini second
    %8:測試用header(好像是漏封包個數，這裡沒用到)
    %9~520為512bytes=256sample(一秒ECG data)
    for k=1:10                                                         %521~550為Gsensor三軸data，sample rata=10Hz，三軸共30bytes(單導極)
        gsensor2(k,1:3) = CombPack(1,520+1+3*(k-1):520+3*k);
        for bdfIndex=1:3
            if(gsensor2(k,bdfIndex)>127)
                gsensor2(k,bdfIndex)=(256-gsensor2(k,bdfIndex))*(-1);
            end
            gsensor2(k,bdfIndex)=gsensor2(k,bdfIndex)*15.6/1000; % 8bits for -2G to 2G, so the resolutions is 15.62 mG
        end
        %         gsensor(k,4)=sqrt(gsensor(k,1)^2+gsensor(k,2)^2+gsensor(k,3)^2);
    end
    
    
    
    %-------------轉換實際電壓值--------------%
    data=[256 1]*reshape(CombPack(9:520),2,256);                       %2bytes組合成一個sample
    for bdfIndex=1:256
        if(data(bdfIndex)>32767)
            data(bdfIndex)=data(bdfIndex)-65535;
        end
    end
    data=data/32768*72.2;%還原mv 1.156Volt/PGA gain when PGA gain = 16, then 72.2 mVolt= 1.156/16
    
    
    deviceId = CombPack(1)+1;
    
    
    
    Tnow=CombPack(3)*60*60*1000+CombPack(4)*60*1000+CombPack(5)*1000+CombPack(6)*256+CombPack(7);% packet time stamp of gateway in msec
    
    if(FIRflag==1)
        Fdata=conv(FIR,data,'same');
    else
        Fdata=data;
    end
    
    if (index(deviceId) == -1)
        index(deviceId)=CombPack(2);
%         tLast(deviceId)=Tnow;
        tLast(deviceId) = Tnow-1000;
        timeDebug = linspace(Tnow-1000,Tnow,256);
    else
        if(CombPack(2)<index(deviceId))       %index會從0~255 若上一個index為255下一個為0必須要加256讓interval的分母不為負號
            CombPack(2)=CombPack(2)+256;
        end
        interval=(Tnow-tLast(deviceId))/((CombPack(2)-index(deviceId)));%這裡是怕漏封包造成時間標錯，假設index進來是0,2(漏了1) 那我分配時間就要除2
        timeDebug=linspace(0,interval,256)+tLast(deviceId);
        
        
        index(deviceId)=CombPack(2);
%         tLast(deviceId)=Tnow;
        
        
    end
    
    timeDebug = timeDebug + timestart2;
    
    packetCount(deviceId) =   packetCount(deviceId) + 1;
    
    
%     appendStIdx = (packetCount(deviceId)-1)*256+1;
%     appendEnIdx = appendStIdx + 256 -1;
%     
%     appendData(deviceId,appendStIdx:appendEnIdx) = data;
%     appendTime(deviceId,appendStIdx:appendEnIdx) = timeDebug;
%     appendPacketTime(deviceId,packetCount(deviceId)) = Tnow;
    
    
    
    
    
    gsensor = gsensor2';
    gsensor = reshape(gsensor,[1,30]);
    
%     url = "https://nestjs-server-dot-ecgproject-1069.appspot.com/ecgdata";
%     thingSpeakURL = url;
    
    mac = string(macTable(deviceId,:));
    
    rssi = 0;
    
    time = [tLast(deviceId) Tnow ];   
    
    time = time + timestart2;
    tLast(deviceId)=Tnow;
     
    jsonFile = jsonencode(table(mac,time,data,gsensor,rssi));
    
    jsonFile = jsonFile(2:end-1);
    
    t = tic ;
    foldername = 'ecg_json';
%     foldername = ['ecg_json_' num2str(deviceId)] ;
    if ~exist(foldername,'dir')
        mkdir(foldername);
    end
    filename = [foldername '/ecg' num2str(time(1)) '.json'];
    fileID = fopen(filename,'w');
    fprintf(fileID,'%s',jsonFile);
    fclose(fileID);
    toc(t);
    
%     options = weboptions('MediaType','application/json','Timeout',10);
%     t = tic ;
%     response = webwrite(thingSpeakURL,jsonFile,options);
%     if (response.statusCode == 200)
% %         disp(time(1));
% %         disp(time(end));
% %         disp([num2str(deviceId)  " Upload success"]);
%             toc(t)
%     else
%         
%         disp('Upload Fail');
%         disp([num2str(deviceId) " " response.message]);
%         
%     end
    if(appendData(1,end) ~= 0 && appendData(2,end)~= 0  && appendData(3,end)~= 0)
        break;
    end
end


