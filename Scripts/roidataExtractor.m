% extracts data from specific ROIs as defined by Power et. al. 2011.
% discardNTimePoints is the number(=N) of initial time points to discard.

function subject_ROI_data = roidataExtractor(pathToRoiTimeseriesFile, discardNTimePoints)
%%ROI definitions. Against each network system, we have relevant atlas ROI names.
brain_system_map = containers.Map;
%brain_system_list = ["default_mode", "fronto_parietal", "salience_network", "attention_network", "somato_motor", "visual", "auditory"]; %old list as per Fig. 1a, Watanabe 2017. Gives the order in which ROI data is structured row-wise in ascending order.

brain_system_list = ["visual", "auditory", "somato_motor", "attention_network", "salience_network", "fronto_parietal", "default_mode"]; %list as per Fig. 2b, Watanabe 2017. Gives the order in which ROI data is structured row-wise in ascending order.



brain_system_map("default_mode") = ["Default mode"];
brain_system_map("fronto_parietal") = ["Fronto-parietal Task Control"];
brain_system_map("salience_network") = ["Salience"];
brain_system_map("attention_network") =  ["Dorsal attention", "Ventral attention", "Cingulo-opercular Task Control"];
brain_system_map("somato_motor") =  ["Sensory/somatomotor Hand", "Sensory/somatomotor Mouth"];
brain_system_map("visual") = ["Visual"];
brain_system_map("auditory") = ["Auditory"];
%%%hacky way to go beyond unresolved spm warning - conn_createmniroi() apparently returning 255 index file for 264 coordinates. So, defining indices for all the brain systems using SevenROIdefinitions.py
brain_system_indices = containers.Map;
%%paste the output of SevenROIdefinitions.py below. Note that these are indexed starting from zero.
brain_system_indices("default_mode") = [73 74 75 76 77 78 79 80 81 82 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 136 138];
brain_system_indices("fronto_parietal") =  [173, 174, 175, 176, 177, 178, 179, 180, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201] ;
brain_system_indices("salience_network") =  [202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219] ;
brain_system_indices("attention_network") =  [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 137, 234, 235, 236, 237, 238, 239, 240, 241, 250, 251, 255, 256, 257, 258, 259, 260, 261, 262, 263] ;
brain_system_indices("somato_motor") =  [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 254] ;
brain_system_indices("visual") =  [142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172] ;
brain_system_indices("auditory") =  [60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72] ;

%%%proceed to extract and arrange subject-wise ROI data across brain systems defined in previous section
subjectwise_ROI_data = {}; %a cell of dimension nsubjects. Each cell will contain nROIs x t data. 
%% extracting as per the ROI definitions in brain_system_indices
	roidata = load(pathToRoiTimeseriesFile);
	subject_ROI_data = []; %contains nROIs time series
	%start with each brain system 
	for index = 1:length(brain_system_list);
		brain_system = brain_system_list(index);
		%fprintf('Arranging %s data for subj %d\n', brain_system, subject);
		brain_system_timeseries = []; %will contain the time-series for selected brain system
		%code block to read through indices of each brain system and simply assign
		indices = brain_system_indices(brain_system);
		%search for regions for the selected brain system
		for index = indices; %add 4 as a) python indices are zero-based, b) first three fields in .data of Condition000.mat are non-ROIs.
			ts_data = cell2mat(roidata.data(index + 4))'; %transpose column vector into row vector timeseries
			ts_data = ts_data(1+discardNTimePoints:end); %discard first initial Points
			brain_system_timeseries = [brain_system_timeseries; ts_data];
		end
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
		avg_brain_system_time_series = mean(brain_system_timeseries); %avg matrix along each column to achieve average timeseries at each timepoint
		subject_ROI_data = [subject_ROI_data; avg_brain_system_time_series]; %append average timeseries for selected brain system for the subject
	end

end

