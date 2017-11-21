function correctedLocs = rPeakDetection(e5, DAT)
    %% threshold and peaks detection in power signal
    threshold = 0.7 * mean (e5);
    timeVector = [1/1000: 1/1000: length(e5)/1000]';

    [peaks,locs] = findpeaks(e5, 'MinPeakDistance', 300, 'MinPeakHeight', threshold);

    peaksValid = [];
    locsValid = [];

%     figure
%     plot(1:length(e5), e5, 'b', 1:length(e5), threshold*ones(size(timeVector)),'r')
%     hold on
%     stem(locs, peaks, 'g', 'LineStyle', 'none')
%     hold off

    %% qrs detection with back search of 0.5 seconds

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

%     figure
%     plot(1:length(DAT.ecg), DAT.ecg)
%     hold  
%     stem(correctedLocs, DAT.ecg(correctedLocs),'g','LineStyle','none' )
end