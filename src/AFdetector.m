%% AF detection
clc
close all
clear 

LIST={...
    'afdb_file-04043_episode-1'
    'afdb_file-04043_episode-2'
    'afdb_file-04043_episode-3'
    'afdb_file-04043_episode-4'
    'afdb_file-04048_episode-1'
    'afdb_file-04048_episode-2'
    'afdb_file-04048_episode-3'
    'afdb_file-04746_episode-1'
    'afdb_file-04746_episode-2'
    'afdb_file-04746_episode-3'
    'afdb_file-05261_episode-1'
    'afdb_file-05261_episode-2'
    'afdb_file-05261_episode-3'
    'afdb_file-05261_episode-4'
    'afdb_file-08219_episode-1'
    'afdb_file-08219_episode-2'
    'afdb_file-08219_episode-3'
    'afdb_file-08219_episode-4'
    };

sensitivities = [];
specificities = [];
accuracies = [];
for j = 1:length(LIST)
    
    close all
    path = strcat('data/DATAF/', LIST(j), '.mat');
    load(path{1});
    ecg = DAT.ecg;
    class = DAT.class;
    annot = DAT.annot;

    ecgFull = fullProcessing(ecg);
    e5 = ecgFull{5};
    correctedLocs = rPeakDetection(e5,DAT);

    %% P-Wave 

    [bHigh, aHigh] = butter(4,0.5/500,'high');
    ecg = zscore(ecg);
    ecg = filter(bHigh,aHigh,ecg);
    stdValues = [0];

    for i = 2 : length(correctedLocs)    
        [qVal, qInd] = min(ecg(correctedLocs(i)-30:correctedLocs(i)));
        realQInd = correctedLocs(i)-30 + qInd;
        stdValues = [stdValues std(ecg(realQInd-100:realQInd))];     
    end

    stdValues(1) = stdValues(2);

    figure
    plot(correctedLocs, stdValues,'o')
    hold
    plot(1:length(ecg),1.35*mean(stdValues)*ones(size(ecg)))
    title('STD across the ECG')
    ylabel('STD')
    xlabel('Time (ms)')

    %% 5 seconds

    threshold = 1.35*mean(stdValues);
    classNossa = zeros(size(ecg));

    for i =1:2500:length(ecg)    
        if i+4999<=length(ecg)
            windowValues = stdValues(find(correctedLocs>=i & correctedLocs<i+4999));
            countUp = length(find(windowValues >= threshold));
            countDown = length(find(windowValues < threshold));    
            if countUp/(countUp + countDown) > 0.2
               classNossa(i:i+4999)=1;
            end
        else
            windowValues = stdValues(find(correctedLocs>=i & correctedLocs<length(ecg)));
            countUp = length(find(windowValues >= threshold));
            countDown = length(find(windowValues < threshold));
            if countUp/(countUp + countDown) > 0.2
               classNossa(i:end)=1;
            end
        end
    end

    figure
    plot(ecg)
    hold 
    plot(class,'r')
    plot(classNossa,'g')
    title('Classified signal')
    xlabel('Time (ms)')
    ylabel('ECG')
    legend('ECG', 'Truth Set', 'Classified')
    
    confusionMatrix = zeros(2);
    for i = 1:length(classNossa)
        confusionMatrix(classNossa(i)+1, class(i)+1) = confusionMatrix(classNossa(i)+1, class(i)+1) + 1;
    end

    sensitivities = [sensitivities confusionMatrix(2,2)/(confusionMatrix(1,2) + confusionMatrix(2,2))];
    specificities = [specificities confusionMatrix(1,1)/(confusionMatrix(2,1) + confusionMatrix(1,1))];
    accuracies = [accuracies (confusionMatrix(1,1) + confusionMatrix(2,2))/(confusionMatrix(2,1) + confusionMatrix(1,2) + confusionMatrix(1,1) + confusionMatrix(2,2))];
    
    file = LIST{j};
    fprintf('File: %s\n', file)
    fprintf('Sensitivity: %f\n', confusionMatrix(2,2)/(confusionMatrix(1,2) + confusionMatrix(2,2)))
    fprintf('Specificity: %f\n', confusionMatrix(1,1)/(confusionMatrix(2,1) + confusionMatrix(1,1)))
    fprintf('Accuracy: %f\n', (confusionMatrix(1,1) + confusionMatrix(2,2))/(confusionMatrix(2,1) + confusionMatrix(1,2) + confusionMatrix(1,1) + confusionMatrix(2,2)))

    % Comentar para correr todos   
    pause
end

%parameters = horzcat(sensitivities', specificities', accuracies');
%xlswrite('data/AFparameters', parameters) 
close all

