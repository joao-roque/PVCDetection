% AF detection

load('data/DATAF/afdb_file-08219_episode-4.mat');

ecg = DAT.ecg;
class = DAT.class;
annot = DAT.annot;

ecgFull = fullProcessing(ecg);
e5 = ecgFull{5};
correctedLocs = rPeakDetection(e5,DAT);

%% RR

distanceToLast = [];

for i = 2 : length(correctedLocs)
    distanceToLast = [distanceToLast correctedLocs(i)-correctedLocs(i-1)];
end

meanWindow = [];

for j = 1 : length(distanceToLast)
    
    if j+249<=length(distanceToLast)
        meanWindow = [meanWindow repmat(mean(distanceToLast(j:j+249)),1,250)];
    else
        meanWindow = [meanWindow repmat(mean(distanceToLast(j:end)),1,length(distanceToLast)-i)];
    end
end

figure
plot(1:length(ecg), ecg)
hold  
stem(correctedLocs, ecg(correctedLocs),'g','LineStyle','none' )
plot(class)
hold off



figure
plot(meanWindow)
% hold 
% plot(class)
% ylim([-1,2])
% hold off

%% P-Wave 

stdValues = [];

for i = 2 : length(correctedLocs)
    
    [qVal, qInd] = min(ecg(correctedLocs(i)-30:correctedLocs(i)));
    
    realQInd = correctedLocs(i)-30 + qInd;
    
    stdValues = [stdValues std(ecg(realQInd-80:realQInd))]; 
    
    
end





