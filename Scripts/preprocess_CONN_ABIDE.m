%This script is for preprocessing the fMRI data from ABIDE groups. It takes a defined list of subject IDs for preprocessing.

%subids = [50977,51011,50970,50965,50989,51035,50983,51034,50992,50991,50974,51007]; %for autistic children of ABIDE I NYU
%subids = [50964, 50998, 50990, 50976, 50994, 50995, 50973]; %for autistic adolescents of ABIDE I NYU
%subids = [51025, 51018, 51023, 51016, 51028, 51015]; %for autistic adults of ABIDE I NYU

%%below section marks the newly matched subjects
%subids = [50286, 50288, 50312, 50295, 50317, 50303, 50306, 50283, 50310, 50281, 50316, 50305]; % ASD children from ABIDE I UniMichigan_Sample1
subid = {};
%subid{end+1} = [50475, 50476, 50477, 50478, 50479, 50480, 50482, 50483, 50484, 50488, 50490, 50491, 50492, 50496, 50498, 50499, 50502, 50505, 50507, 50508, 50514, 50525, 50527, 50531]; %asd adults from Watanabe et. al. 2017
%subid{end+1} = [50439, 50440, 50441, 50442, 50444, 50446, 50450, 50452, 50454, 50455, 50457, 50462, 50463, 50465, 50467, 50471, 50472, 50473, 50474]; %td adults from Watanabe et. al. 2017

%subid{end+1} = [50358, 50355, 50372, 50377, 50332, 50359, 50364, 50337, 50334, 50376, 50333]; % TD  children from ABIDE I UniMichigan_Sample1
%subid{end+1} = [50298, 50274, 50273, 50272, 50297, 50323, 50314, 50290, 50296, 50315, 50324, 50291]; % ASD adolesc  from ABIDE I UniMichigan_Sample1
%subid{end+1} = [50370, 50371, 50342, 50328, 50360, 50351, 50350, 50347, 50381, 50330]; % TD  adolesc  from ABIDE I UniMichigan_Sample1

%subid{end+1} = [50404, 50405, 50410, 50408, 50402, 50403, 50412, 50406]; % ASD adolesc from ABIDE I UniMichigan_Sample2
subid{end+1} = [50416, 50383, 50418, 50423, 50422, 50426, 50421, 50419]; % TD  adolesc from ABIDE I UniMichigan_Sample2

%subid{end+1} = [29068, 29065, 29060, 29058, 29067, 29070, 29057, 29059, 29066, 29062]; % ASD adults from ABIDE II ABIDEII-ETH_1
%subid{end+1} = [29082, 29094, 29071, 29081, 29091, 29093, 29075, 29079, 29092, 29078]; % TD adults from ABIDE II ABIDEII-ETH_1

%subids = [50980, 51007, 50991, 51014, 50977, 50965, 50979, 50978, 51035, 51034, 51003, 50968, 50970, 50975, 50983, 50982, 51006]; % ASD children from ABIDE I phenotypic_NYU
%subids = [51084, 51121, 51086, 51087, 51120, 51082, 51090, 51069, 51089, 51093, 51085, 51091, 51081, 51083, 51080]; % TD children from ABIDE I phenotypic_NYU

%subid{end+1} = [50976, 50964, 50998, 50984, 50994, 50985, 50995, 50972, 50990, 50973]; % ASD adolsc from ABIDE I phenotypic_NYU
%subids = [51104, 51096, 51108, 51127, 51101, 51107, 51109, 51095, 51125, 51094]; % TD  adolsc from ABIDE I phenotypic_NYU

%subid{end+1} = [51024, 51028, 51015, 51016, 51021, 51018, 51017, 51029, 51025, 51023]; % ASD adults from ABIDE I phenotypic_NYU
%subid{end+1} = [51146, 51148, 51155, 51153, 51113, 51149, 51119, 51154, 51117, 51116]; % TD  adults from ABIDE I phenotypic_NYU

%subid{end+1} = [50498, 50480, 50482, 50531, 50477, 50514, 50496, 50483, 50478, 50491, 50499, 50485, 50475, 50507]; % ASD adults from ABIDE I USM
%subid{end+1} = [50455, 50440, 50462, 50450, 50452, 50469, 50445, 50434, 50472, 50467, 50441, 50473]; % TD adults from ABIDE I USM

%caution: the four filenames following this line are older. And kept for legacy.
%filename = 'conn_testproject.mat';
%filename = 'conn_project_ABIDEINYU_children.mat'; %for ABIDE I NYU ASD children
%filename = 'conn_project_ABIDEINYU_adolescents.mat'; %for ABIDE I NYU ASD adolescents
%filename = 'conn_project_ABIDEINYU_adults.mat'; %for ABIDE I NYU ASD adults

%% below section for newly matched final subjects
%filename = 'conn_ABIDEI_UMich_Samp1_ASD_child.mat' % ASD children from ABIDE I UniMichigan_Sample1
filenames = {};
%filenames{end+1} = "watanabe_2017_asd_adult.mat"; % asd adults from Watanabe & Rees, 2017.
%filenames{end+1} = "watanabe_2017_td_adult.mat";  % td adults from Watanabe & Rees, 2017.

%filenames{end+1} = "conn_ABIDEI_UMich_Samp1_TD_child.mat";  % TD children from ABIDE I UniMichigan_Sample1
%filenames{end+1} = "conn_ABIDEI_UMich_Samp1_ASD_adolsc.mat"; % ASD adolesc  from ABIDE I UniMichigan_Sample1
%filenames{end+1} = "conn_ABIDEI_UMich_Samp1_TD_adolsc.mat"; % TD  adolesc  from ABIDE I UniMichigan_Sample1
%filenames{end+1} = 'conn_ABIDEI_UMich_Samp2_ASD_adolsc.mat'; % ASD adolesc from ABIDE I UniMichigan_Sample2
filenames{end+1} = 'conn_ABIDEI_UMich_Samp2_TD_adolsc.mat'; % TD  adolesc from ABIDE I UniMichigan_Sample2
%filenames{end+1} = 'conn_ABIDEII_ETH_ASD_adult.mat'; % ASD adults from ABIDE II ABIDEII-ETH_1
%filenames{end+1} = 'conn_ABIDEII_ETH_TD_adult.mat'; % TD  adults from ABIDE II ABIDEII-ETH_1
%filename = 'conn_ABIDEI_NYU_ASD_child.mat' % ASD children from ABIDE I phenotypic_NYU
%filename = 'conn_ABIDEI_NYU_TD_child.mat' % TD children from ABIDE I phenotypic_NYU
%filenames{end+1} = 'conn_ABIDEI_NYU_ASD_adolsc.mat' % ASD adolsc from ABIDE I phenotypic_NYU
%filename = 'conn_ABIDEI_NYU_TD_adolsc.mat' % TD adolsc from ABIDE I phenotypic_NYU
%filenames{end+1} = 'conn_ABIDEI_NYU_ASD_adult.mat'; % ASD adults from ABIDE I phenotypic_NYU
%filenames{end+1} = 'conn_ABIDEI_NYU_TD_adult.mat'; % TD  adults from ABIDE I phenotypic_NYU

%filenames{end+1} = "conn_ABIDEI_USM_ASD_adult.mat"; % ASD adults from ABIDE I USM
%filenames{end+1} = "conn_ABIDEI_USM_TD_adult.mat"; % TD  adults from ABIDE I USM

TR=2; %repetition time
ISNEW = 1; %isnew
OVERWRITE = 0; %overwrite
for ii = 1:length(subid);
	subids = cell2mat(subid(ii));
	filename =  convertStringsToChars(filenames{ii})
	nsubjects = length(subids);
	%%see if extraction is necessary
	%anat_file_gz = 'anat.nii.gz';
	anat_file_gz = 'mprage.nii.gz';
	func_file_gz = 'rest.nii.gz';
	funcfiles_gz = cellstr(conn_dir(func_file_gz));
	anatfiles_gz = cellstr(conn_dir(anat_file_gz));
	fprintf('fetching compressed functional files....\n');
	FUNC_FILE_gz = getRelevantSubjectFiles(funcfiles_gz, subids);
	fprintf('fetching compressed anatomical files....\n');
	ANAT_FILE_gz = getRelevantSubjectFiles(anatfiles_gz, subids);
	extractfiles(FUNC_FILE_gz);
	extractfiles(ANAT_FILE_gz);
	%extraction is done
	%%search for right number of extracted files
	anat_file = anat_file_gz(1:end-3); %remove .gz
	func_file = func_file_gz(1:end-3); %remove .gz
	funcfiles = cellstr(conn_dir(func_file));
	anatfiles = cellstr(conn_dir(anat_file));
	fprintf('fetching functional files....\n');
	FUNC_FILE = getRelevantSubjectFiles(funcfiles, subids);
	fprintf('fetching anatomical files....\n');
	ANAT_FILE = getRelevantSubjectFiles(anatfiles, subids);

	if rem(length(FUNC_FILE),nsubjects),error('mismatch number of functional files %n', length(FUNC_FILE));
	end
	if rem(length(ANAT_FILE),nsubjects),error('mismatch number of anatomical files %n', length(ANAT_FILE));
	end
	nsessions=length(FUNC_FILE)/nsubjects;
	FUNC_FILE=reshape(FUNC_FILE,[nsubjects,nsessions]);
	ANAT_FILE={ANAT_FILE{1:nsubjects}};
	disp([num2str(size(FUNC_FILE,1)),' subjects']);
	disp([num2str(size(FUNC_FILE,2)),' sessions']);
	%we have the files now

	%%TBD: check if parallel config(Background for Linux) is possible - https://web.conn-toolbox.org/resources/cluster-configuration
	%%start with conn batch definitions
	%Watanabe 2017 - realignment, unwarping, slice timing correction,normalization to the standard template (ICBM 152) and spatial smoothing
	clear batch;
	batch.filename=fullfile((pwd),filename);
	batch.Setup.isnew=ISNEW;
	batch.Setup.nsubjects=nsubjects;
	batch.Setup.RT=TR;
	batch.Setup.functionals=repmat({{}},[nsubjects,1]);
	% Point to functional volumes for each subject/session
	for nsub=1:nsubjects,
	for nses=1:nsessions,
	batch.Setup.functionals{nsub}{nses}{1}=FUNC_FILE{nsub,nses};
	end;
	end
	batch.Setup.structurals=ANAT_FILE;
	% Point to anatomical volumes for each subject
	batch.Setup.rois.names={'power2011', 'globalBrainMask'};
	%the following was created by conn_createmniroi('test.nii', 'coords.txt', 4, 2). The *coords.txt file was created using SevenROIsDefinition.py
	%batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','test.nii');
	%following 'all264_4mm_combined.nii' was created using get_marsbar_rois
	batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','PP264_all_ROIs_combined_10mmradius.nii');
	%batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','Powerall264_combined_4mmSphere_3mmres.nii');
	%batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','PP264_all_ROIs_4mmSphere_2mmres.nii'); %use same roi file for all subjects & sessions
	batch.Setup.rois.files{2}= '/home/vinsea/Documents/spm12/toolbox/FieldMap/brainmask.nii'; %for global signal regression
	
	%batch.Setup.conditions.names=cellstr([repmat('Session',[nconditions,1]),num2str((1:nconditions)')]);
	%TBD: verify if preprocessing steps are needed.
	batch.Setup.conditions.names = {'rest'};
	for nsub=1:nsubjects;
		batch.Setup.conditions.onsets{1}{nsub}{1}=0;
		batch.Setup.conditions.durations{1}{nsub}{1}=inf;
	end;
	%batch.Setup.preprocessing.coregtomean = 1; %Coregistration to 0 for first. 1 for mean. 
	%batch.Setup.preprocessing.boundingbox = [-90 -126 -72;90 90 108];
	batch.Setup.preprocessing.voxelsize_anat = 1; %target anat voxel size
	batch.Setup.preprocessing.voxelsize_func = 3; %target func voxel size
	batch.Setup.preprocessing.fwhm=8; %8mm FWHM smoothing
	batch.Setup.preprocessing.steps={'default_mni'}; % set {} for user-ask
	batch.Setup.preprocessing.sliceorder= getSliceOrder(filename);
	batch.Setup.overwrite=OVERWRITE; % 1 or 0.
	batch.Setup.done=1;
	%% CONN Denoising
	batch.Denoising.confounds = {}; %use default
	batch.Denoising.filter=[0.01, 0.1]; %frequency filter (band-pass values, in Hz)
	batch.Denoising.done=1;

	conn_batch(batch);
end
%% Display using CONN GUI - launches conn gui to explore results
%conn
%conn('load',fullfile(pwd, filename));
%conn gui_results

function sliceorder = getSliceOrder(filename)
	if contains(filename, 'ETH');
		sliceorder = {'descending'};
	elseif contains(filename, 'UMich');
		sliceorder = {'ascending'};
	elseif contains(filename, 'NYU');
		sliceorder = {'interleaved (Siemens)'};
	elseif contains(filename, 'USM');
		sliceorder = {'interleaved (Siemens)'};
	end 
end

function extractfiles(filearray);
	for index = 1:length(filearray);
		candidate = char(filearray(index));
		if isempty(candidate);
			continue
		end
		if exist(candidate(1:end-3)) == 0; %remove .gz and check if file doesn't exist
		  fprintf('Extracting %s\n', candidate)
		  gunzip(candidate);
		  fprintf('Now, deleting %s\n', candidate);
		  delete(candidate);
		end
	end
end

%filters relevant paths containing the subject IDs mentioned in subids file.
function result = getRelevantSubjectFiles(filearray, subids);
	result = {};
	foundSubjects = [];
	for index = 1:length(filearray);
		candidate = filearray(index);
		for indsub = 1:length(subids);
			subid = subids(indsub);
			if contains(candidate, num2str(subid));
				fprintf('Found file for sub %d\n', subid)
				result{end + 1} = char(candidate);
				foundSubjects = [foundSubjects subid];
				break
			end
		end
		%result
	end
	differ = setdiff(subids, foundSubjects);
	if ~isempty(differ)
	    fprintf('Caution: no files found for %g\n', differ);
        end
end
 
