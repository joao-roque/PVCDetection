% AF detection
close all

load('data/DATAF/afdb_file-08219_episode-2.mat');

ecg = DAT.ecg;
class = DAT.class;
annot = DAT.annot;

ecgFull = fullProcessing(ecg);
e5 = ecgFull{5};
correctedLocs = rPeakDetection(e5,DAT);

%% RR
% 
% distanceToLast = [];
% 
% for i = 2 : length(correctedLocs)
%     distanceToLast = [distanceToLast correctedLocs(i)-correctedLocs(i-1)];
% end
% 
% meanWindow = [];
% 
% for j = 1 : length(distanceToLast)
%     
%     if j+249<=length(distanceToLast)
%         meanWindow = [meanWindow repmat(mean(distanceToLast(j:j+249)),1,250)];
%     else
%         meanWindow = [meanWindow repmat(mean(distanceToLast(j:end)),1,length(distanceToLast)-i)];
%     end
% end
% 
% figure
% plot(1:length(ecg), ecg)
% hold  
% stem(correctedLocs, ecg(correctedLocs),'g','LineStyle','none' )
% plot(class)
% hold off
% 
% 
% 
% figure
% plot(meanWindow)
% % hold 
% % plot(class)
% % ylim([-1,2])
% % hold off

%% P-Wave 

[bHigh, aHigh] = butter(4,0.5/500,'high');

ecg = zscore(ecg)

figure
plot(ecg)

ecg = filter(bHigh,aHigh,ecg);

stdValues = [0];

for i = 2 : length(correctedLocs)
    
    [qVal, qInd] = min(ecg(correctedLocs(i)-30:correctedLocs(i)));
    
    realQInd = correctedLocs(i)-30 + qInd;
    
    stdValues = [stdValues std(ecg(realQInd-100:realQInd))]; 
    
end

stdValues(1) = stdValues(2);

% vq1 = interp1(correctedLocs,stdValues,length(ecg));

figure
plot(correctedLocs, stdValues,'o')
hold
plot(1:length(ecg),1.35*mean(stdValues)*ones(size(ecg)))


%% 5 seconds

threshold = 1.35*mean(stdValues);
classNossa = zeros(size(ecg));

for i =1:2500:length(ecg)
    
    if i+4999<=length(ecg)
        windowValues = stdValues(find(correctedLocs>=i & correctedLocs<i+4999));
        countUp = length(find(windowValues >= threshold));
        countDown = length(find(windowValues < threshold));
    
        if countUp/(countUp + countDown) > 0.2
           classNossa(i:i+4999)=1.5;
        end
    else
        windowValues = stdValues(find(correctedLocs>=i & correctedLocs<length(ecg)));
        countUp = length(find(windowValues >= threshold));
        countDown = length(find(windowValues < threshold));

        if countUp/(countUp + countDown) > 0.2
           classNossa(i:end)=1.5;
        end
    end
end


figure
plot(ecg)
hold 
plot(class,'r')
plot(classNossa,'g')




