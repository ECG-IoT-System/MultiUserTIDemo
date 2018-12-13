clc;
clear all;
close all;
load('FIRNum.mat');
load('h2.mat');
figure(1);
windowSizeSec = 6;
shiftSizeSec = 0.1; %% draw speed
overlap = windowSizeSec-shiftSizeSec;

collectSeconds = 20+1;

appendData = appendData(1:device_num,1:collectSeconds*256);
appendTime= appendTime(1:device_num,1:collectSeconds*256);
appendTime = appendTime-min(min(appendTime));
appendTime = appendTime./1000;

appendDataFIR = zeros(device_num,collectSeconds*256);


for i = 1:device_num
    appendData(i,:) = appendData(i,:) - mean(appendData(i,:));
    appendDataFIR(i,:) = conv(appendData(i,:),FIR,'same');
end


drawIdxMax = (collectSeconds-overlap)/(windowSizeSec-overlap);
figure(1);
for i = 1 : drawIdxMax
%         suptitle('Multi-User Demo');
    timeStart = (i-1)*shiftSizeSec + min(min(appendTime));
    for j = 1 : device_num
    subplot(3,1,j);
    plot(appendTime(j,:), appendDataFIR(j,:));
    xlim([timeStart timeStart+windowSizeSec]);
    title(['device ' num2str(j) ]);

    end

    
    drawnow;
end