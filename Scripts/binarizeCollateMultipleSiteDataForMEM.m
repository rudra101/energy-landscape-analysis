%this code will have three sections,
%a) descriptions of file path to fMRI timeseries and number of subjects in each age group
%b) binarize subjects data and collate them. 
%c) creating a result directory for each age group and feeding the binarized collated data into MEM model
global exactEzakiPathPrefix withoutGSRDirPrefix withGSRDirPrefix folderPrefix fMRItimeseriesfolder;

%%define the data location and number of subjects.
exactEzakiPathPrefix = '/home/vinsea/Downloads/Exact Ezaki steps/';
withoutGSRDirPrefix = '/home/vinsea/Downloads/Without GSR Timeseries/';
withGSRDirPrefix = '/home/vinsea/Downloads/GSR_Timeseries/';
folderPrefix = 'timeseries_';
fMRItimeseriesfolder = 'fMRI timeseries';
sphereROIradiusSuffix = 'mm_ROI_radius';
%format is a cell array of subject filepath and their counts (as string) 
%fill for asd subjects
%asd_child = {};
%asd_child{end+1} = ["ABIDEI_UMich_Samp1_ASD_child", "12"];
%asd_child{end+1} = ["ABIDEI_NYU_ASD_child", "17"];
%asd_adolsc = {};
%asd_adolsc{end+1} = ["ABIDEI_UMich_Samp1_ASD_adolsc", "12"];
%asd_adolsc{end+1} = ["ABIDEI_UMich_Samp2_ASD_adolsc", "8"];
%asd_adolsc{end+1} = ["ABIDEI_NYU_ASD_adolsc", "10"];
%asd_adult = {};
%asd_adult{end+1} = ["watanabe_2017_asd_adult", "24"];
%asd_adult{end+1} = ["ABIDEII_ETH_ASD_adult", "10"];
%asd_adult{end+1} = ["ABIDEI_NYU_ASD_adult", "10"];
%asd_adult{end+1} = ["ABIDEI_USM_ASD_adult", "14"];
%%fill for typical subjects
%td_child = {};
%td_child{end+1} = ["ABIDEI_UMich_Samp1_TD_child", "11"];
%td_child{end+1} = ["ABIDEI_NYU_TD_child", "15"];
td_adolsc = {};
%td_adolsc{end+1} = ["ABIDEI_UMich_Samp1_TD_adolsc", "10"];
td_adolsc{end+1} = ["ABIDEI_UMich_Samp2_TD_adolsc", "8"];
%td_adolsc{end+1} = ["ABIDEI_NYU_TD_adolsc", "10"];
%td_adult = {};
%td_adult{end+1} = ["watanabe_2017_td_adult", "19"];
%td_adult{end+1} = ["ABIDEII_ETH_TD_adult", "10"];
%td_adult{end+1} = ["ABIDEI_NYU_TD_adult", "10"];
%td_adult{end+1} = ["ABIDEI_USM_TD_adult", "12"];

%%binarize subjects data and collate them for MEM fit
%[asd_GSR_cell, asd_withoutGSR_cell] = deal(cell(1,3)); %cells with three columns for child, adolsc, adults.
%[td_GSR_cell, td_withoutGSR_cell] = deal(cell(1,3)); %cells with three columns for child, adolsc, adults.
[asd_exactEzaki_cell, td_exactEzaki_cell] = deal(cell(1,3)); %cells with three columns for child, adolsc, adults. 

%%%no gsr
%%get ASD
%asd_withoutGSR_cell{1} = collectFilesBinarizeAndCollate(0,false, asd_child, "asd_child_collated");
%asd_withoutGSR_cell{2} = collectFilesBinarizeAndCollate(0,false, asd_adolsc, "asd_adolsc_collated");
%asd_withoutGSR_cell{3} = collectFilesBinarizeAndCollate(0,false, asd_adult, "asd_adult_collated");
%%get TD
%td_withoutGSR_cell{1} = collectFilesBinarizeAndCollate(0,false, td_child, "td_child_collated");
%td_withoutGSR_cell{2} = collectFilesBinarizeAndCollate(0,false, td_adolsc, "td_adolsc_collated");
%td_withoutGSR_cell{3} = collectFilesBinarizeAndCollate(0,false, td_adult, "td_adult_collated");
%
%%%with gsr
%%get ASD
%asd_GSR_cell{1} = collectFilesBinarizeAndCollate(0,true, asd_child, "asd_child_collated");
%asd_GSR_cell{2} = collectFilesBinarizeAndCollate(0,true, asd_adolsc, "asd_adolsc_collated");
%asd_GSR_cell{3} = collectFilesBinarizeAndCollate(0,true, asd_adult, "asd_adult_collated");
%%get TD
%td_GSR_cell{1} = collectFilesBinarizeAndCollate(0,true, td_child, "td_child_collated");
%td_GSR_cell{2} = collectFilesBinarizeAndCollate(0,true, td_adolsc, "td_adolsc_collated");
%td_GSR_cell{3} = collectFilesBinarizeAndCollate(0,true, td_adult, "td_adult_collated");

%%exact Ezaki steps
%get ASD
for sphereRadius = [4 10];
	%collectFilesBinarizeAndCollate(0, 2, sphereRadius, asd_child, "asd_child_collated");
	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adolsc, "asd_adolsc_collated");
	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adult, "asd_adult_collated");
	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adult, "watanabe_asd_adult_collated");
end
%get TD
for sphereRadius = [4 10];
	%collectFilesBinarizeAndCollate(0, 2, sphereRadius, td_child, "td_child_collated");
	collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adolsc, "td_adolsc_collated");
	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adult, "td_adult_collated");
	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adult, "watanabe_td_adult_collated");
end

%%start feeding into MEM model
for age = ["adolsc"];
%for age = ["child", "adolsc", "adult"];
for group = ["asd"];
%for group = ["td"];
%for group = ["asd", "td"];
for sphereRadius = [4 10];
	%for flag = [0 1 2]; % 0 - no GSR, 1 - GSR, 2 - exact Ezaki step 
	flag = 2;
	group_name = sprintf('%s_%s_collated', group, age);
	%filename = sprintf('%s_%s_collated', group, age);
	filename = sprintf('%s_%s_collated_%dmm.dat', group, age, sphereRadius);
	%filename = sprintf('watanabe_%s_%s_collated', group, age);
	fprintf('Processing %s. Flag %d. \n', filename, flag);
	processUsingMEM(flag, sphereRadius, group_name, filename);
	%end
end
end
end

%function to binarize and collate data, gsr flag to know if gsr or without gsr folder is considered.
%sphereRadius is the radius of spheres used to create ROIs.
function collectFilesBinarizeAndCollate(discardNTimePoints, flag, sphereRadius, data, outputFileName)
  global exactEzakiPathPrefix withoutGSRDirPrefix withGSRDirPrefix folderPrefix fMRItimeseriesfolder;
  filepathprefix = ""; 
  if flag == 0; filepathprefix = withoutGSRDirPrefix;
  elseif flag == 1; filepathprefix = withGSRDirPrefix;
  elseif flag == 2; filepathprefix = exactEzakiPathPrefix;
  end
  collatedSubj = []; 
  for jj = 1:length(data);   
      folderInfo = data{jj};
      folderName = folderInfo(1);
      subjCount = str2num(folderInfo(2));
      %fprintf('Index %d. Folder %s. Subj count %d.\n', jj, folderName, subjCount);
      
      for subj = 1:subjCount;
       filename = sprintf('ROI_Subject%s_Condition000.mat', num2str(subj, '%03.f'));	      
       filepath = sprintf('%s%s%s/%s/%dmm_ROI_radius/%s', filepathprefix, folderPrefix, folderName, fMRItimeseriesfolder, sphereRadius, filename);
       %fprintf('Extracting ROI data from %s\n', filepath);
       subjData = roidataExtractor(filepath, discardNTimePoints);
       collatedSubj = [collatedSubj pfunc_01_Binarizer(subjData, 0.0)];
      end
  end
  sz = size(collatedSubj);
  %proceed to save the collated data using the outputFileName
  resultFilePath = sprintf('%s%s_%dmm.dat', filepathprefix, outputFileName, sphereRadius);
  %fprintf('Saving %dx%d data to %s\n', sz(1), sz(2), resultFilePath);
  writematrix(collatedSubj, resultFilePath, 'Delimiter', 'tab');
end

function processUsingMEM(flag, sphereRadius, groupName, inputFileName)
	global exactEzakiPathPrefix withoutGSRDirPrefix withGSRDirPrefix folderPrefix fMRItimeseriesfolder;
	%filepathprefix = ""; 
	outputFolderPrefix = "";
	if flag == 0; outputFolderPrefix = withoutGSRDirPrefix;
	elseif flag == 1; outputFolderPrefix = withGSRDirPrefix;
	elseif flag == 2; outputFolderPrefix = exactEzakiPathPrefix;
	end
        params.ProcessingType = 2; % 1: Energy Landscape Construction,
				   % 2: Individual analysis
	params.fReadBasinData = 0; % 1 for if individual analysis AND basin data is to be read
	params.BasinDataFile = ''; % specify in case of fReadBasinData = 1;
	params.DataType = 2; % 1 & 2 for continuous and binarized data respectively.
	params.OutputFolder = sprintf('%s/%s_FullAnalysis/%dmm_Radius/', outputFolderPrefix, groupName, sphereRadius); %give a folder path which will contain all the analysis
	params.Threshold = 0.0; %threshold for binarizing. Zero defaults to mean
	roifilepath = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/roiname.dat';
	params.RoiFile = roifilepath; %set the file containing ROI names
	params.fRoi = 1; % 0 for not reading a ROI file.
	params.fSaveBasinList = 1;
	params.InputFile = sprintf('%s/%s', outputFolderPrefix, inputFileName);
	mkdir(params.OutputFolder); %make the output directory
	main(params);
end

