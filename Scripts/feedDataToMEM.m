%this script mimics StartProgram functionality and calls main() program within energy landscape analysis
%Start date: 25/08/20. Author: Rudradeep Mukherjee
%%defining params for MEM model implementation written by T. Ezaki
params.ProcessingType = 2; % 1: Energy Landscape Construction,
			   % 2: Individual analysis
params.fReadBasinData = 0; % 1 for if individual analysis AND basin data is to be read
%skipping defining BasinDataFile, InputFile for now.
params.BasinDataFile = ''; % specify in case of fReadBasinData = 1;
params.DataType = 2; % 1 & 2 for continuous and binarized data respectively.
params.OutputFolder = ''; %give a folder path which will contain all the analysis
params.Threshold = 0.0; %threshold for binarizing. Zero defaults to mean
roifilepath = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/roiname.dat';
params.RoiFile = roifilepath; %set the file containing ROI names
params.fRoi = 1; % 0 for not reading a ROI file.
params.fSaveBasinList = 1; %save basin list as part of full analysis
%params.MaximizationType = 'PL'; % pseudo-likelihood function
%params.MaximizationType = 'ML'; % default, maximum-likelihood function

%%start with defining paths to subject data and save destination 
subjects = 1; %IDs of subjects to be analysed
parentpath = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/';
foldername = 'ABIDEI_UMich_Samp2_adolsc_timeseries'; %for ABIDE I UMich Sample 2 adolescent autistics
%foldername = 'project_ABIDEINYU_children_timeseries'; %for ABIDE I NYU autistics children
%foldername = 'ABIDEIIAutistics_Priyanka_timeseries';
fileprefix = 'subject';

for subj = subjects;
	filepath = sprintf('%s%s/%s%d.dat', parentpath, foldername, fileprefix, subj);
	params.InputFile = filepath;
	params.OutputFolder = sprintf('%s%s/%s%s%d_FullAnalysis/', parentpath, foldername, fileprefix, subj); %the path where analysis will reside.
%	params.OutputFolder = sprintf('%s%s%d_%s_FullAnalysis/', parentpath, fileprefix, subj, params.MaximizationType); %the path where analysis will reside.
	mkdir(params.OutputFolder); %create the folder for results
	main(params); %call main() of MEM model
end

