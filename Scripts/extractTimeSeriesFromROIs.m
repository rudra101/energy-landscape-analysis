%This script tries to collate time series from ROIs mentioned in the following definitions starting from line 9.
%Primarily written for systems present in Power et. al. 2011, which has been referenced by Watanabe, Rees 2017. The atlas is present as conn/rois/PP_264*.nii and .txt files. These atlas files were created using conn_mniroi() based on coordinates provided by Power 2011 template file on web.
%(Should be generalisable by changing the names as per relevant atlases).
%The time series are read from relevant <conn_project>/results/preprocessing/ROI_Subject${id}_Condition000.mat

%%define file dir, subjects and names for preprocessed data 
%data_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/conn_project_ABIDEINYU_children/results/preprocessing/'; %for ABIDE I NYU autistics children
%data_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/ABIDEIIAutistics_Priyanka/results/preprocessing/'; %for ABIDE II NYU autistics children(selected from Priyanka's data)
%data_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/conn_project_ABIDEI_UMich_Samp2_adolsc/results/preprocessing/'; %for ABIDE I UMich Sample 2 adolescent data
%%data dir for fresh preprocessed data
data_dir_prefix = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/';
data_dir_suffix = '/results/preprocessing/';
%foldername = 'ABIDEI_UMich_Samp1_ASD_child'; % ASD children from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp1_TD_child';  % TD children from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp1_ASD_adolsc'; % ASD adolesc  from ABIDE I UniMichigan_Sample1
foldername = 'ABIDEI_UMich_Samp1_TD_adolsc'; % TD  adolesc  from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp2_ASD_adolsc'; % ASD adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'ABIDEI_UMich_Samp2_TD_adolsc'; % TD  adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'ABIDEII_ETH_ASD_adult'; % ASD adults from ABIDE II ABIDEII-ETH_1
%foldername = 'ABIDEII_ETH_TD_adult'; % TD  adults from ABIDE II ABIDEII-ETH_1
%foldername = 'ABIDEI_NYU_ASD_adult'; % ASD adults from ABIDE I phenotypic_NYU
%foldername = 'ABIDEI_NYU_TD_adult'; % TD  adults from ABIDE I phenotypic_NYU
data_dir = strcat(data_dir_prefix, strcat('conn_',foldername), data_dir_suffix)


%result_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/project_ABIDEINYU_children_timeseries'; %result directory for ABIDE I NYU autisitcs chidren 
%result_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/ABIDEIIAutistics_Priyanka_timeseries'; %result directory for ABIDEII NYUI autistics(by Priyanka's selection) 
%result_dir = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/ABIDEI_UMich_Samp2_adolsc_timeseries'; %result directory for ABIDEI UMich Sample 2 adolescents 

%%result dir for freshly matched subjects
result_dir = strcat(data_dir_prefix, strcat('timeseries_', foldername))


file_prefix = 'ROI_Subject'; file_suffix = '_Condition000.mat';
subjects = 1:10; % id range for reading subjects ROI_Subject${id}_Condition000.mat files
subjectsToCollate = 1:10; %caution: id of subjects whose time-series data are to be concatenated. Ids should be present in `subjects` variable. If subject IDs are repeated, the concatenation will also be repeated. For instance, if `subjects`=[1:5] and `subjectsToCollate`= [2 2 3 4], then subject 2's data will be concatenated twice followed by subjs with ids 3 and 4.

%%ROI definitions. Against each network system, we have relevant atlas ROI names.
%brain_system_map = containers.Map;
%brain_system_list = ["default_mode", "fronto_parietal", "salience_network", "attention_network", "somato_motor", "visual", "auditory"];
%
%brain_system_map("default_mode") = ["Default mode"];
%brain_system_map("fronto_parietal") = ["Fronto-parietal Task Control"];
%brain_system_map("salience_network") = ["Salience"];
%brain_system_map("attention_network") =  ["Dorsal attention", "Ventral attention", "Cingulo-opercular Task Control"];
%brain_system_map("somato_motor") =  ["Sensory/somatomotor Hand", "Sensory/somatomotor Mouth"];
%brain_system_map("visual") = ["Visual"];
%brain_system_map("auditory") = ["Auditory"];
%%%hacky way to go beyond unresolved spm warning - conn_createmniroi() apparently returning 255 index file for 264 coordinates. So, defining indices for all the brain systems using SevenROIdefinitions.py
%brain_system_indices = containers.Map;
%%paste the output of SevenROIdefinitions.py below. Note that these are indexed starting from zero.
%brain_system_indices("default_mode") = [73 74 75 76 77 78 79 80 81 82 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 136 138];
%brain_system_indices("fronto_parietal") =  [173, 174, 175, 176, 177, 178, 179, 180, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201] ;
%brain_system_indices("salience_network") =  [202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219] ;
%brain_system_indices("attention_network") =  [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 137, 234, 235, 236, 237, 238, 239, 240, 241, 250, 251, 255, 256, 257, 258, 259, 260, 261, 262, 263] ;
%brain_system_indices("somato_motor") =  [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 254] ;
%brain_system_indices("visual") =  [142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172] ;
%brain_system_indices("auditory") =  [60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72] ;
%
%%%proceed to extract and arrange subject-wise ROI data across brain systems defined in previous section
%subjectwise_ROI_data = {}; %a cell of dimension nsubjects. Each cell will contain nROIs x t data. 
%%subjectwise_binarized_data = {}; %a cell of dimension nsubjects. Each cell will contain nROIs x t data. 
%%% extracting as per the ROI definitions in brain_system_indices
%for subject = subjects;
%	file_loc = strcat(data_dir, file_prefix, num2str(subject, '%03.f'), file_suffix);
%	roidata = load(file_loc);
%	subject_ROI_data = []; %contains nROIs time series
%	%start with each brain system 
%	for index = 1:length(brain_system_list);
%		brain_system = brain_system_list(index);
%		%fprintf('Arranging %s data for subj %d\n', brain_system, subject);
%		brain_system_timeseries = []; %will contain the time-series for selected brain system
%		%code block to read through indices of each brain system and simply assign
%		indices = brain_system_indices(brain_system);
%		%search for regions for the selected brain system
%		for index = indices; %add 4 as a) python indices are zero-based, b) first three fields in .data of Condition000.mat are non-ROIs.
%			ts_data = cell2mat(roidata.data(index + 4))'; %transpose column vector into row vector timeseries
%			brain_system_timeseries = [brain_system_timeseries; ts_data];
%		end
%%this comment block contains code for reading names and matching them with brain systems. Not needed now, as ROI labeling is not working.
%%		regions = brain_system_map(brain_system);
%%		%search for regions for the selected brain system
%%		for index_name = 1:length(roidata.names);
%%			roiname = string(roidata.names(index_name));
%%			if contains(roiname, regions); %check for match
%%				ts_data = cell2mat(roidata.data(index_name))'; %transpose column vector into row vector timeseries
%%				brain_system_timeseries = [brain_system_timeseries; ts_data];
%%			end
%%		end
%		avg_brain_system_time_series = mean(brain_system_timeseries); %avg matrix along each column to achieve average timeseries at each timepoint
%		subject_ROI_data = [subject_ROI_data; avg_brain_system_time_series]; %append average timeseries for selected brain system for the subject
%	end
%%
%	subjectwise_ROI_data{end + 1} = subject_ROI_data; %assign the raw data to each subject
%	%binarizedData = pfunc_01_Binarizer(subject_ROI_data, 0.0); 
%	%subjectwise_binarized_data{end + 1} = binarizedData; %assign the binarized data to each subject
%end
%%%now, store the timeseries as N rois x t for each individual subject in a separate file
%mkdir(result_dir); %try to create a directory
%for ind = 1:length(subjects); %writing a general form for future use.
%	subj = subjects(ind);
%	%binary_data = cell2mat(subjectwise_binarized_data(ind)); %index in order of subject IDs
%	raw_data = cell2mat(subjectwise_ROI_data(ind)); %index in order of subject IDs
%	filepath_raw_data = sprintf('%s/subject%d_continuous.dat', result_dir, subj);
%	writematrix(raw_data, filepath_raw_data, 'Delimiter', 'tab'); %save the data to subject file. using \t (Tab) as delimiter.
%end

%%extract all the 264ROIs data, binarize them and store them in 264xt files for each subject
subjectwise_ROI_264_data = {};
for subject = subjects;
	file_loc = strcat(data_dir, file_prefix, num2str(subject, '%03.f'), file_suffix);
	roidata = load(file_loc);
	subjectTimeSeriesBinarized = [];
	for index = 1:264; % add 3 as first three fields in .data of Condition000.mat are non-ROIs.
		ts_data = cell2mat(roidata.data(index + 3))'; %transpose column vector into row vector timeseries
		subjectTimeSeriesBinarized = [subjectTimeSeriesBinarized; pfunc_01_Binarizer(ts_data, 0.0)];
	end
	subjectwise_ROI_264_data{end+1} = subjectTimeSeriesBinarized;
end
%%collate subjects time-series data in single file.
collatedData_264rois = [];
for subj_id = subjectsToCollate; %writing a general form for future use.
	for ind = 1:length(subjects);
		curr_subj = subjects(ind);
		if curr_subj == subj_id; %found the subject for concatenation
		binarizedData_264rois = cell2mat(subjectwise_ROI_264_data(ind));
		collatedData_264rois = [collatedData_264rois binarizedData_264rois];
		break
		end
	end
end
label = sprintf('%.0f,', subjectsToCollate); label = label(1:end-1); %a label with concatenated subject IDs
filepath = sprintf('%s/collated264ROI_subjects-%s.dat', result_dir, label);
writematrix(collatedData_264rois, filepath, 'Delimiter', 'tab'); %save the data to subject file. using \t (Tab) as delimiter.

