%this code will have three sections,
%a) descriptions of file path to fMRI timeseries and number of subjects in each age group
%b) binarize subjects data and collate them. 
%c) creating a result directory for each age group and feeding the binarized collated data into MEM model
global exactEzakiPathPrefix withoutGSRDirPrefix withGSRDirPrefix folderPrefix fMRItimeseriesfolder;
global ADOS_TOTAL ADOS_SOCIAL ADOS_RRB ADOS_COMM AGES FIQS ASD TD;

%%define the data location and number of subjects.
exactEzakiPathPrefix = '/home/vinsea/Downloads/Exact Ezaki steps/';
withoutGSRDirPrefix = '/home/vinsea/Downloads/Without GSR Timeseries/';
withGSRDirPrefix = '/home/vinsea/Downloads/GSR_Timeseries/';
folderPrefix = 'timeseries_';
fMRItimeseriesfolder = 'fMRI timeseries';
sphereROIradiusSuffix = 'mm_ROI_radius';
%format is a cell array of subject filepath and their counts (as string) 
%fill for asd subjects
asd_child = {};
asd_child{end+1} = ["ABIDEI_UMich_Samp1_ASD_child", "12"];
asd_child{end+1} = ["ABIDEI_NYU_ASD_child", "17"];
asd_adolsc = {};
asd_adolsc{end+1} = ["ABIDEI_UMich_Samp1_ASD_adolsc", "12"];
asd_adolsc{end+1} = ["ABIDEI_UMich_Samp2_ASD_adolsc", "8"];
asd_adolsc{end+1} = ["ABIDEI_NYU_ASD_adolsc", "10"];
asd_adult = {};
%asd_adult{end+1} = ["watanabe_2017_asd_adult", "24"];
asd_adult{end+1} = ["ABIDEII_ETH_ASD_adult", "10"];
asd_adult{end+1} = ["ABIDEI_NYU_ASD_adult", "10"];
asd_adult{end+1} = ["ABIDEI_USM_ASD_adult", "14"];
%%fill for typical subjects
td_child = {};
td_child{end+1} = ["ABIDEI_UMich_Samp1_TD_child", "11"];
td_child{end+1} = ["ABIDEI_NYU_TD_child", "15"];
td_adolsc = {};
td_adolsc{end+1} = ["ABIDEI_UMich_Samp1_TD_adolsc", "10"];
td_adolsc{end+1} = ["ABIDEI_UMich_Samp2_TD_adolsc", "8"];
td_adolsc{end+1} = ["ABIDEI_NYU_TD_adolsc", "10"];
td_adult = {};
%td_adult{end+1} = ["watanabe_2017_td_adult", "19"];
td_adult{end+1} = ["ABIDEII_ETH_TD_adult", "10"];
td_adult{end+1} = ["ABIDEI_NYU_TD_adult", "10"];
td_adult{end+1} = ["ABIDEI_USM_TD_adult", "12"];

%% Ages of subjects in each group. Note: These ages tally against subject IDs mentioned in preprocess_CONN_ABIDE.m. As conn_dir sorts the subids on that file execution, the ages mentioned here are against the sorted subids.
% the following code generated using helperrepo.py. The vars in upper case (such as ADOS_COMM, AGES, FIQS and so on) are global variables.
% SECTION I - defines values of variables for different ados sites.
ADOS_COMM = containers.Map;
%NOTE: adults have ADOS_TOTAL scores
ADOS_COMM("ABIDEII_ETH_ASD_adult") =  [2.0, 2.0, 2.0, 3.0, 2.0, 5.0, 3.0, 1.0, 2.0, 3.0] ;
ADOS_COMM("ABIDEI_NYU_ASD_adolsc") =  [16.0, 12.0, 16.0, 12.0, 22.0, 20.0, 12.0, 17.0, 12.0, 16.0] ;
ADOS_COMM("ABIDEI_NYU_ASD_adult") =  [5.0, 4.0, 3.0, 2.0, 3.0, 5.0, 5.0, 5.0, 6.0, 4.0] ;
ADOS_COMM("ABIDEI_NYU_ASD_child") =  [20.0, 16.0, 15.0, 15.0, 9.0, 17.0, 17.0, 19.0, 15.0, 10.0, 13.0, 22.0, 15.0, 8.0, 20.0, 15.0, 16.0] ;
ADOS_COMM("ABIDEI_UMich_Samp1_ASD_adolsc") =  [20.0, 13.0, 14.0, 17.0, 16.0, 13.0, nan, 18.0, 17.0, 14.0, 19.0, 17.0] ;
ADOS_COMM("ABIDEI_UMich_Samp1_ASD_child") =  [8.0, 18.0, 10.0, 13.0, 22.0, 12.0, 14.0, 18.0, 22.0, 15.0, 15.0, 15.0] ;
ADOS_COMM("ABIDEI_UMich_Samp2_ASD_adolsc") =  [16.0, 15.0, 16.0, 15.0, 21.0, 18.0, 18.0, 18.0] ;
ADOS_COMM("ABIDEI_USM_ASD_adult") =  [4.0, 4.0, 4.0, 6.0, 4.0, 3.0, 2.0, 4.0, 3.0, 5.0, 3.0, 6.0, 4.0, 1.0] ;

%%create a R file with same order of subjects as the empirical measures recorded in the subsequent sections below
%% for writing age, FIQ and ADOS (only for ASD) scores
for group = ["asd"];
%for group = ["asd", "td"];
for age = ["child", "adolsc", "adult"];
%	%convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "ageWriter");
%	%convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "fiqWriter");
	%convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "adosWriter");
	%convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "adosSocialWriter"); % ADI_R_SOCIAL_TOTAL_A for child and adolsc. ADOS_SOCIAL for adult.
	%convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "adosRRBWriter"); % ADI_RRB_TOTAL_C for child and adolsc. ADOS_STEREO_BEHAV for adult.
%	convertAndWriteforRplot(eval(sprintf('%s_%s', group, age)), group, age, "adosCommWriter"); % ADI_R_VERBAL_TOTAL_BV for child and adolsc. ADOS_COMM for adult.
end
end


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
%%for sphereRadius = [10];
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_child, "asd_child_collated");
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adolsc, "asd_adolsc_collated");
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adult, "asd_adult_collated");
% the following code to remove ABIDE I NYU ASD adult(id: 51024, subid - 7)
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adult, "asd_adult_collated_outlierRemoved");
%	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, asd_adult, "watanabe_asd_adult_collated");
%end
%%get TD
%for sphereRadius = [10];
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_child, "td_child_collated");
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adolsc, "td_adolsc_collated");
%	collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adult, "td_adult_collated");
%	%collectFilesBinarizeAndCollate(5, 2, sphereRadius, td_adult, "watanabe_td_adult_collated");
%end

%%start feeding into MEM model
%for age = ["adult"];
%for age = ["child", "adolsc", "adult"];
%for group = ["asd"];
%for group = ["td"];
%for group = ["asd", "td"];
%for sphereRadius = [10];
%	%for flag = [0 1 2]; % 0 - no GSR, 1 - GSR, 2 - exact Ezaki step 
%	flag = 2;
%	group_name = sprintf('%s_%s_collated', group, age);
%	%filename = sprintf('%s_%s_collated_%dmm.dat', group, age, sphereRadius);
%	%filename = sprintf('watanabe_%s_%s_collated', group, age);
%	%filename = 'asd_adult_collated_outlierRemoved_10mm.dat';
%	fprintf('Processing %s. Flag %d. \n', filename, flag);
%	processUsingMEM(flag, sphereRadius, group_name, filename);
	%end
%end
%end
%end

%% special code to generate functional connectivity matrices for all indiviidual subjects in a particular group
%for group = ["asd", "td"];
%for age = ["child", "adolsc", "adult"];
%   %a = generalEmpiricalDataParser(age, group, eval(sprintf('%s_%s', group, age)), "FCcalc");
%   %eval(sprintf('%s.%s.FCMatrices = a;', upper(group), age));
%   %% prepare for saving the FC matrices to .mat file.
%   %eval(sprintf('FCMatrices = %s.%s.FCMatrices;', upper(group), age));
%   %locToSave = sprintf('exactEzaki_%s_%s_FCMatrices_10mm.mat', group, age);
%   %save(locToSave, 'FCMatrices');
%end
%end

%% special code to generate data points for individual subjects as per each group's `NetModsFC`. Please refer to `generateFCvalsForModules.m` and its usage in `plotgenerator.m` for context.
%% NOTE that `NetModsFC` should be generated first by running `plotgenerator.m`
%for group = ["asd", "td"];
%for age = ["child", "adolsc", "adult"];
%   data = eval(sprintf('%s_%s', group, age));
%   a = generalEmpiricalDataParser(age, group, data, "NetModsCalc");
%   convertAndWriteforRplot(a, group, age, "netModsWriter");
%end
%end


%%special code to generate major, minor state freqs for all empirical subjects
for group = ["asd", "td"];
for age = ["child", "adolsc", "adult"];
 %a = generalEmpiricalDataParser(age, group, eval(sprintf('%s_%s', group, age)), "freqCalc");
 a = generalEmpiricalDataParser(age, group, eval(sprintf('%s_%s', group, age)), "freqCalc_Combn");
 convertAndWriteforRplot(a, group, age, "freq_Combn");
 %eval(sprintf('%s_%s_freqs = a;', lower(group), age));
 %convertAndWriteforRplot(a, group, age, "freq");
 %writeToCsv(a, group, age, "freqWrt");
end
end

%%special code to get a) directMajorTrans, b) directMinorTrans c) indirectMajorTrans for empirical subjects
%for group = ["asd", "td"];
%for age = ["child", "adolsc", "adult"];
%	a = generalEmpiricalDataParser(age, group, eval(sprintf('%s_%s', group, age)), "transCalc");
%	%eval(sprintf('%s_%s_trans = a;', lower(group), age));
%	convertAndWriteforRplot(a, group, age, "trans");
%end
%end

%%special code to get basinDurations for empirical subjects
%for group = ["asd", "td"];
%for age = ["child", "adolsc", "adult"];
%	a = generalEmpiricalDataParser(age, group, eval(sprintf('%s_%s', group, age)), "durationCalc");
%	%eval(sprintf('%s_%s_durs = a;', lower(group), age));
%	convertAndWriteforRplot(a, group, age, "duration");
%end
%end

% generates abide site names in particular order
function printSiteNamesInParticularOrder(data)
 for jj = 1:length(data);
        folderInfo = data{jj};
        folderName = folderInfo(1);
	fprintf('\"%s\":\n', folderName);
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
      %below folder for saving binarized data of each individual subject.
      %subjectFolder = sprintf('%s%s%s/%s/%dmm_ROI_radius/binarizedData/', filepathprefix, folderPrefix, folderName, fMRItimeseriesfolder, sphereRadius); 
      %mkdir(subjectFolder);
    
      for subj = 1:subjCount;
       % this code to ignore outlier ASD adult (subID: 51024) with age = 39.1 years.
       if folderName == "ABIDEI_NYU_ASD_adult" && subj == 7;
	       fprintf('ignoring subj %d from %s\n', subj, folderName);
	       continue;
       end
       filename = sprintf('ROI_Subject%s_Condition000.mat', num2str(subj, '%03.f'));	      
       filepath = sprintf('%s%s%s/%s/%dmm_ROI_radius/%s', filepathprefix, folderPrefix, folderName, fMRItimeseriesfolder, sphereRadius, filename);
       %fprintf('Extracting ROI data from %s\n', filepath);
       subjData = roidataExtractor(filepath, discardNTimePoints);
       binarizedData = pfunc_01_Binarizer(subjData, 0.0); 
       collatedSubj = [collatedSubj binarizedData];
       %save binarized data of individual subjects for later use.  
       %subjectFilepath = sprintf('%s%s.dat', subjectFolder, filename(1:end-4)); 
       %writematrix(binarizedData, subjectFilepath, 'Delimiter', 'tab');
      end
  end
  sz = size(collatedSubj);
  %proceed to save the collated data using the outputFileName
  resultFilePath = sprintf('%s%s_%dmm.dat', filepathprefix, outputFileName, sphereRadius);
  %%fprintf('Saving %dx%d data to %s\n', sz(1), sz(2), resultFilePath);
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
	params.InputFile = sprintf('%s/%s', outputFolderPrefix, inputFileName); %set the input file name
	mkdir(params.OutputFolder); %make the output directory
	main(params);
end

