%% PVC detection
clc
clear all
close all

LIST={...
    'DPVC_116', 'DPVC_201', 'DPVC_221', 'DPVC_233', ... 
    'DPVC_119', 'DPVC_203', 'DPVC_223', 'DPVC_106', ...
    'DPVC_200', 'DPVC_210', 'DPVC_228' };

sensitivities = [];
specificities = [];
accuracies = [];

for j = 1:length(LIST)
    
    close all
    path = strcat('data/DATPVC/', LIST(j), '.mat');
    load(path{1});
    ecg = fullProcessing(DAT.ecg);
    e5 = ecg{5};

    % Detect Peaks
    correctedLocs = rPeakDetection(e5, DAT);

    % Index of PVC
    PVC_index = [];
    for i = 1:length(DAT.pvc)
       if DAT.pvc(i) == 1
          PVC_index = [PVC_index, i];
       end

    end

    %stem(DAT.ind(PVC_index), DAT.ecg(DAT.ind(PVC_index)), 'r', 'LineStyle', 'none')
    features = extractFeatures(DAT.ecg, DAT.ind);

    % Boxplot
    figure
    boxplot(features, DAT.pvc, 'Labels', {'normal', 'PVC'})
    title 'Boxplot of RS interval'
    hold off

    %% Defined Rule

    % area/distance - new feature to classify PVC - ardist
    % PVC --> 0.2 < ardist < 0.5
    % Distance introduces too much error
    % Only area --> area > 50 

    output = zeros(size(features));
    %>50  >0.2
    output(find(features>50)) = 1;

    confusionMatrix = zeros(2);
    for i = 1:length(output)
        confusionMatrix(output(i)+1, DAT.pvc(i)+1) = confusionMatrix(output(i)+1, DAT.pvc(i)+1) + 1;
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
%xlswrite('data/PVCparameters', parameters) 
close all