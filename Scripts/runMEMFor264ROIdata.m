%special file for running MEM on binarized data files having 264xt time points.
%uses only relevant codes from Ezaki's main() script as the original landscape-analysis code expects N <=12 ROIs.
%%start with defining paths to subject data and save destination 
subjectsCollated = 1:10; %IDs of subjects to be analysed
parentpath = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/';
%foldername = 'timeseries_ABIDEI_UMich_Samp1_ASD_child'; % ASD children from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp1_TD_child';  % TD children from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp1_ASD_adolsc'; % ASD adolesc from ABIDE I UniMichigan_Sample1
foldername = 'timeseries_ABIDEI_UMich_Samp1_TD_adolsc'; % TD adolesc from ABIDE I UniMichigan_Sample1
%foldername = 'timeseries_ABIDEI_UMich_Samp2_ASD_adolsc'; % ASD adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'timeseries_ABIDEI_UMich_Samp2_TD_adolsc'; % TD adolesc from ABIDE I UniMichigan_Sample2
label = sprintf('%.0f,', subjectsCollated); label = label(1:end-1); %a label with concatenated subject IDs
filename = sprintf('collated264ROI_subjects-%s.dat', label);

filepath = sprintf('%s%s/%s', parentpath, foldername, filename)
result_file_h = sprintf('%s%s/h_matrix_All264rois_subj %s.txt', parentpath, foldername, label);
result_file_J = sprintf('%s%s/J_matrix_All264rois_subj %s.txt', parentpath, foldername, label);
%% run MEM model.
binarizedData = importdata(filepath);
%can't use ML inferrer as the it also invokes 2^264 patterns 
%[h,J] = pfunc_02_Inferrer_ML(binarizedData); %was the default in Mr. Ezaki's code.
[h,J] = pfunc_02_Inferrer_PL(binarizedData); %useful for N>=30 ROIs
%cannot find accuracy as this code generate 2^264 patterns.
%[probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
writematrix(h, result_file_h, 'Delimiter', 'tab'); %save the data to subject file. using \t (Tab) as delimiter.
writematrix(J, result_file_J, 'Delimiter', 'tab'); %save the data to subject file. using \t (Tab) as delimiter.


