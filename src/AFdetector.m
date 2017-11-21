% AF detection

load('data/DATAF/afdb_file-08219_episode-4.mat');

ecg = DAT.ecg;
class = DAT.class;
annot = DAT.annot;

ecgFull = fullProcessing(ecg);
e5 = ecgFull{5};

%% 
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
        [maxPeakWindow,loc1] = max(ecg(locs(j)-500:locs(j)));
        loc2 = 500 - loc1;
        correctedLocs = [correctedLocs, locs(j)-loc2-1];
    else
        [maxPeakWindow,loc] = max(0:locs(j));
        correctedLocs = [correctedLocs, loc];
    end
end

figure
plot(1:length(ecg), ecg)
hold  
%stem(locs(2:length(locs))-0.171*1000, DAT.ecg(locs(2:length(locs))-0.171*1000),'g','LineStyle','none')
stem(correctedLocs, ecg(correctedLocs),'g','LineStyle','none' )
%stem(locs, peaks, 'g', 'LineStyle', 'none')
