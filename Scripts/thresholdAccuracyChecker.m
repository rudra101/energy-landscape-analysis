global result_dir file_prefix file_suffix;
data_dir_prefix = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/';

foldername = 'timeseries_ABIDEI_UMich_Samp1_ASD_child'; % ASD children from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp1_TD_child';  % TD children from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp1_ASD_adolsc'; % ASD adolesc  from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp1_TD_adolsc'; % TD  adolesc  from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp2_ASD_adolsc'; % ASD adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'timeseries_ABIDEI_UMich_Samp2_TD_adolsc'; % TD  adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'timeseries_ABIDEII_ETH_ASD_adult'; % ASD adults from ABIDE II ABIDEII-ETH_1
%foldername = 'timeseries_ABIDEII_ETH_TD_adult'; % TD  adults from ABIDE II ABIDEII-ETH_1
%foldername = 'timeseries_ABIDEI_NYU_ASD_adult'; % ASD adults from ABIDE I phenotypic_NYU
%foldername = 'timeseries_ABIDEI_NYU_TD_adult'; % TD adults from ABIDE I phenotypic_NYU

result_dir = strcat(data_dir_prefix, foldername)

file_prefix = 'subject'; file_suffix = '_continuous.dat';
subjectIDs = 1:12;
subjectsToCollate = 1:12;
thresholdRange = [-0.15:0.01:0.15];
collatedData = []; index = 1;
[accuracy,reliability] = deal(zeros(1, length(thresholdRange)));
h_cell = {}; J_cell = {};
for threshold = thresholdRange;
	fprintf('collating and analysing data for threshold %f\n', threshold);
        [probN, prob1, prob2, rD, r, h, J] =accuracyOfCollatedData(subjectsToCollate, threshold);
	h_cell{end+1} = h; J_cell{end+1} = J;
	accuracy(index) = rD; reliability(index) = r/rD;
        index = index + 1;
end
% find the desired threshold
[maxAccuracy, accIndx] = max(accuracy);
threshAcc = thresholdRange(accIndx);
%calculate the probabilities again
h = cell2mat(h_cell(accIndx)); J = cell2mat(J_cell(accIndx));
collatedData = collateSubjects(subjectsToCollate, threshAcc); 
[probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, collatedData);

label = sprintf('%.0f-', subjectsToCollate); label = label(1:end-1); %a label with concatenated subject IDs
filepath = sprintf('%s/collated-binarized%s.dat', result_dir, label);
writematrix(collatedData, filepath, 'Delimiter', 'tab'); %save the data to subject file. using \t (Tab) as delimiter.
%plot the collated data
message = sprintf('. (MaxAcc,Thresh)= (%f,%f). Rel = %f', maxAccuracy, threshAcc, reliability(accIndx));
accuracyPlotter(thresholdRange, accuracy, reliability, label, message);
fprintf('Collated data. Accuracy = %f, reliability= %f\n',rD, r/rD);
%%plot the probability
%probabilityPlotter(0, probN, prob2, prob1, label);
%%plot the moments
%beta = 0.24;
%momentPlotter(0, beta, h, J, collatedData, label);

%%plot accuracy for individual subjects
subjectWiseAcc = [];
for subject = subjectIDs
fprintf('checking accuracy for subject %d at threshold %f\n', subject, threshAcc)
[probN, prob1, prob2, rD, r, h, J] = accuracyOfCollatedData(subject, threshAcc);
subjectWiseAcc(end+1) = rD;
end
%plot the accuracy plots
fig = figure; bar(subjectWiseAcc); xlabel('subjects');  ylabel('accuracy');
title(sprintf('subject wise accuracy at threshold %f', threshAcc));
saveas(fig, sprintf('accuracy_barplot %s.jpg', label));

function accuracyPlotter(thresholdRange, accuracy, reliability, label, message)
	h = figure(1);
	plot(thresholdRange, accuracy, 'b'); hold on;
	plot(thresholdRange, reliability, 'r');
	xlabel('threshold for binarization');
	ylabel('value');
	figureTitle = sprintf('Model fit for subjects %s', label);
	title(strcat(figureTitle, message));
	legend('Accuracy of fit', 'Estimation reliability');
	filename = sprintf('Subjects %s - accuracy.jpg', label);
	saveas(h, filename);
	hold off;
end

%binarize data of subjectIDs using threshold and find the accuracy of collated subjects  
function [probN, prob1, prob2, rD, r, h, J] = accuracyOfCollatedData(subjectsToCollate, threshold);
	collatedData = collateSubjects(subjectsToCollate, threshold); 
	[h,J] = pfunc_02_Inferrer_ML(collatedData);
	[probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, collatedData);
end

%collate binarized data from subjectIDs using a threshold
function collatedData = collateSubjects(subjectIDs, threshold)
global result_dir file_prefix file_suffix;
	collatedData = [];
	for subject = subjectIDs;
		filename = sprintf('%s/%s%d%s', result_dir, file_prefix, subject, file_suffix);
		originalData = importdata(filename);
		binarizedData = pfunc_01_Binarizer(originalData, threshold);
		collatedData = [collatedData binarizedData]; %store the particular binarized data
	end
end


%accuracy = zeros(1,length(thresholdRange));
%OLD CODE: below code for finding optimal thresholds for each subject - which is not recommended.
%for subject = subjectIDs
%	filename = sprintf('%s/%s%d%s', result_dir, file_prefix, subject, file_suffix);
%	originalData = importdata(filename);
%	fprintf('Finding accuracy for subject %d.\n', subject)
%	[maxAcc, threshFound, binarizedData] = maximiseModelFit(thresholdRange, originalData, subject);
%	fprintf('Max accuracy for subject %d is %f at threshold %f\n\n', subject, maxAcc, threshFound)
%	collatedData = [collatedData binarizedData]; %store the particular binarized data
%end

