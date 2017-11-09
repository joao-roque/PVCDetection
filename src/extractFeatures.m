function features = extractFeatures(DAT)
    %% Extract Features

    % Distance to last R peak
    % Window of 2 ms - distance to peak

    distanceToLast = [0];
    for i = 2:length(DAT.ind)
        distanceToLast = [distanceToLast DAT.ind(i) - DAT.ind(i-1)];    
    end

    windowDist1 = [];
    windowDist2 = [];
    for i = 1:length(DAT.ind)
        diff1 = DAT.ecg(DAT.ind(i)) - DAT.ecg(DAT.ind(i)-5);
        diff2 = DAT.ecg(DAT.ind(i)) - DAT.ecg(DAT.ind(i)+5);
        windowDist1 = [windowDist1 diff1/DAT.ecg(i)];
        windowDist2 = [windowDist2 diff2/DAT.ecg(i)];
    end

    features = [distanceToLast' windowDist1' windowDist2'];

end