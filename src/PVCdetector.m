%% PVC detection
clc
clear
load('data/DATPVC/DPVC_116.mat')
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
title 'Boxplot of area'
hold off

%% Defined Rule

% area/distance - new feature to classify PVC - ardist
% PVC --> 0.2 < ardist < 0.5
% Distance introduces too much error
% Only area --> area >50 

output = zeros(size(features));
%>50  >0.2
output(find(features>50)) = 1;

confusionMatrix = zeros(2);
for i = 1:length(output)
    confusionMatrix(output(i)+1, DAT.pvc(i)+1) = confusionMatrix(output(i)+1, DAT.pvc(i)+1) + 1;
end

fprintf('Sensitivity: %f\n', confusionMatrix(2,2)/(confusionMatrix(1,2) + confusionMatrix(2,2)))
fprintf('Specificity: %f\n', confusionMatrix(1,1)/(confusionMatrix(2,1) + confusionMatrix(1,1)))
fprintf('Accuracy: %f\n', (confusionMatrix(1,1) + confusionMatrix(2,2))/(confusionMatrix(2,1) + confusionMatrix(1,2) + confusionMatrix(1,1) + confusionMatrix(2,2)))
