function features = extractFeatures(ecg , ind)
    %% Extract Features

    % Distance to last R peak
    distanceToLast = [0];
    for i = 2:length(ind)
        distanceToLast = [distanceToLast ind(i) - ind(i-1)];    
    end

    areas = [];
    % Extract min after R peak
    for i = 1:length(ind)
       if ind(i)+120 < length(ecg)
           window = ecg(ind(i):(ind(i)+120)); 
           [~, index] = max(-window);
           realMin = ind(i)+ index - 1;
           areas = [areas realMin - ind(i)];
       else
           final = length(ecg) - ind(i);
           window = ecg(ind(i):(ind(i)+final-1)); 
           [~, index] = max(-window);
           realMin = ind(i)+ index - 1;
           areas = [areas realMin - ind(i)];
       end
    end
    
    %features = [distanceToLast' areas'./mean(areas)];
    features = [areas'];
    %features = [areas'./distanceToLast'];
    
end