%% PVC detection

load('data/DATPVC/DPVC_119.mat')
ecg = fullProcessing(DAT.ecg);
e5 = ecg{5};

%% threshold and peaks detection in power signal
threshold = 0.7 * mean (e5);
timeVector = [1/1000: 1/1000: length(e5)/1000]';

% figure
% plot(timeVector, e5, 'b', timeVector, threshold*ones(size(timeVector)),'r')

[peaks,locs] = findpeaks(e5, 'MinPeakDistance', 300, 'MinPeakHeight', threshold);

peaksValid = [];
locsValid = [];

figure
plot(1:length(e5), e5, 'b', 1:length(e5), threshold*ones(size(timeVector)),'r')
hold on
stem(locs, peaks, 'g', 'LineStyle', 'none')
hold off

%% qrs detection. back search of 0.5 seconds

correctedLocs=[];
for j=1:length(locs)
    if j>=2        
        % max of the range of 500 values
        [maxPeakWindow,loc1] = max(DAT.ecg(locs(j)-500:locs(j)));
        loc2 = 500 - loc1;
        correctedLocs = [correctedLocs, locs(j)-loc2-1];
    else
        [maxPeakWindow,loc] = max(0:locs(j));
        correctedLocs = [correctedLocs, loc];
    end
end

figure
plot(1:length(DAT.ecg), DAT.ecg)
hold  
%stem(locs(2:length(locs))-0.171*1000, DAT.ecg(locs(2:length(locs))-0.171*1000),'g','LineStyle','none')
stem(correctedLocs, DAT.ecg(correctedLocs),'g','LineStyle','none' )
%stem(locs, peaks, 'g', 'LineStyle', 'none')

% Index of PVC
PVC_index = [];
for i = 1:length(DAT.pvc)
   if DAT.pvc(i) == 1
      PVC_index = [PVC_index, i];
   end
    
end

stem(DAT.ind(PVC_index), DAT.ecg(DAT.ind(PVC_index)), 'r', 'LineStyle', 'none')
%stem(DAT.ind, DAT.ecg(DAT.ind), 'r','LineStyle', 'none')

features = extractFeatures(DAT);

%% Classify

svmStruc = svmtrain(features, DAT.pvc);

load('DATPVC/DPVC_106.mat');
newData = extractFeatures(DAT);
classes = svmclassify(svmStruc, newData);

PVC_index = [];
for i = 1:length(DAT.pvc)
   if DAT.pvc(i) == 1
      PVC_index = [PVC_index, i];
   end
    
end

classified_PVC_index = [];
for i = 1:length(classes)
   if classes(i) == 1
      classified_PVC_index = [classified_PVC_index, i];
   end
    
end

figure
plot(1:length(DAT.ecg), DAT.ecg)
hold on
stem(DAT.ind(PVC_index), DAT.ecg(DAT.ind(PVC_index)), 'r', 'LineStyle', 'none')
hold on
stem(DAT.ind(classified_PVC_index), DAT.ecg(DAT.ind(classified_PVC_index)), 'g', 'LineStyle', 'none')


%% Oi

x = 1;