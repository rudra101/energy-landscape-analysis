function [spin_avg, corr_avg] = empiricalDataEstimation(binarizedData)
%expects a binarized data Nrois x t form and calculates spin averages over the empirical data run
[nodeNumber, t] = size(binarizedData);
spin_avg = mean(binarizedData, 2);
spinConfig = zeros(1, nodeNumber);
corr_avg = zeros(nodeNumber);
for jj = 1:t; 
spinConfig = binarizedData(:,jj)';
corr_avg = corr_avg + computeCorrlMatrix(spinConfig);
end
corr_avg = corr_avg / t; 
end

