% general empirical data parser which uses typeOfTask to calculate relevant metric for empirical data
% task "freqCalc" => matrix where each row contain indv subject data for [majorStFreq minorStCombnFreq].
% task "transCalc" => matrix where each row contain indv subject data for [directMajorTrans directMinorTrans indirectMajorTrans]
% task "durationCalc" => matrix where each row contain indv subject data for [meanDurationMajorState]
function result = generalEmpiricalDataParser(age, group, data, typeOfTask)
      global ASD TD exactEzakiPathPrefix folderPrefix fMRItimeseriesfolder;
%% start initialising the vars which will contain the results
      switch typeOfTask
	case "freqCalc"
	 freqs = []; 
	case "transCalc"
	 trans = [];
	case "durationCalc"
	 durations = [];
	case "FCcalc"
	 FCMats = {};
        case "NetModsCalc"
	 subjNetMods = {}; % to contain python dicts in subsequent code.	
        case "freqCalc_Combn"
	 freqsCombn = [];
        otherwise
	 error(sprintf('typeOfTask %s is not recognised', typeOfTask));
      end
%% a check if the global vars are set.
      if length(exactEzakiPathPrefix) == 0 || length(folderPrefix) == 0 || length(fMRItimeseriesfolder) == 0;
      error('either of exactEzakiPathPrefix, folderPrefix, fMRItimeseriesfolder unset. Please refer to file `binarizeCollateMultipleSiteDataForMEM.m` for an example of how these vars are set.')
      end
%% first load the MEM fit results on collated data.
      MEMData = load(sprintf('exactEzaki_%s_%s_MEM_results_10mm.mat', lower(group), age));
      [LocalMinIndx, BasinGrph] = getLocalMinIndx(MEMData.h, MEMData.J);
      %majorSts = LocalMinIndx(MEMData.majorstateIndices);
      sphereRadius = 10;
%% then, begin processing the subject data in ascending order
      for jj = 1:length(data);   
	folderInfo = data{jj};
	folderName = folderInfo(1);
	subjCount = str2num(folderInfo(2));
        for subj = 1:subjCount; %add subject data in ascending order
        filename = sprintf('ROI_Subject%s_Condition000', num2str(subj, '%03.f'));	      
        rawDataFilepath = sprintf('%s%s%s/%s/%dmm_ROI_radius/%s.mat', exactEzakiPathPrefix, folderPrefix, folderName, fMRItimeseriesfolder, sphereRadius, filename);
	binarizedDataFilepath = sprintf('%s%s%s/%s/%dmm_ROI_radius/binarizedData/%s.dat', exactEzakiPathPrefix, folderPrefix, folderName, fMRItimeseriesfolder, sphereRadius, filename);
	binarizedData = importdata(binarizedDataFilepath);
	switch typeOfTask
	case "freqCalc_Combn"
	 freqMajorSt = getFreqOfStates(binarizedData, LocalMinIndx, BasinGrph, MEMData.majorstateIndices); 
	 freqMinorSt = 1 - sum(freqMajorSt);
	 freqMjrStCombn = freqMajorSt(1) + freqMajorSt(2);
	 freqsCombn = [freqsCombn; freqMjrStCombn freqMinorSt];	
	case "freqCalc"
	 freqMajorSt = getFreqOfStates(binarizedData, LocalMinIndx, BasinGrph, MEMData.majorstateIndices); 
	 freqMinorSt = 1 - sum(freqMajorSt);
	 freqs = [freqs; freqMajorSt freqMinorSt];
	case "transCalc"
	 transFreqs = getTransFreq(binarizedData, LocalMinIndx, BasinGrph, MEMData.majorstateIndices); 	
	 trans = [trans; transFreqs];
        case "durationCalc"
	 meanDuration = getDurationOfStates(binarizedData, LocalMinIndx, BasinGrph, MEMData.majorstateIndices);
	 durations = [durations; meanDuration];
        case "FCcalc" % calculate FC of an individual subject
	  meanROIActivity = roidataExtractor(rawDataFilepath, 5);
	  meanROIActivity = flip(meanROIActivity); % as the network order list considered in `generateFCvalsForModules.m` is completely reverse to that of `roidataExtractor.m`.
	  FCMats{end+1} = calculateFC(meanROIActivity);
        case "NetModsCalc"
	  netModsFC = eval(sprintf('%s.%s.NetModsWithFC', upper(group), age)); 
	  subjfcMat = eval(sprintf('%s.%s.FCMatrices{%d}', upper(group), age, subj)); 
	  subjNetMods{end+1} = calculateSubjNetModFC(netModsFC, subjfcMat);
        end
        end
      end
      if typeOfTask == "freqCalc_Combn"; result = freqsCombn;
      elseif typeOfTask == "freqCalc"; result = freqs;
      elseif typeOfTask == "transCalc"; result = trans;
      elseif typeOfTask == "durationCalc"; result = durations;
      elseif typeOfTask == "FCcalc"; result = FCMats;
      elseif typeOfTask == "NetModsCalc"; result = subjNetMods;
      else error(sprintf("No result set for task %s", typeofTask));
      end 
      close all;
end

% each row in meanROIActivity(size: nRow x t) has the mean time activity of a particular region
% the output - nRow x nRow matrix of FC values (Z/Fisher-transformed);
% the diagonal will have Inf;
function FCMat = calculateFC(meanROIActivity);
    nRow = size(meanROIActivity, 1);
    FCMat = ones(nRow);
    for ii = 1:nRow;
     for jj = ii+1:nRow;
      val = corrcoef(meanROIActivity(ii, :),meanROIActivity(jj, :));
      FCMat(ii, jj) = val(1,2);
      FCMat(jj, ii) = val(1,2);
     end
    end
    FCMat = atanh(FCMat); % do the Fisher transformation
end

% returns an identical dict as NetModsDict with values of across and within FC mean
% being substituted with that calculated from `subjFCMat`.
% please consult the definition in `plotgenerator.m`
function res = calculateSubjNetModFC(NetModsDict, subjFCMat)
%% Caution: MATLAB doesn't support deepcopy of python objects.
%% using custom code to achieve deep copy. 
%% Moral: Python Dict in MATLAB is unsupported on many (important) levels. Think about coding in python for preserving sanity.
   newNetModDict = deepCopyDict(NetModsDict); % create a fresh copy that doesn't change the original
   % deal with majorSt
   fcMajor = calcSubjFC(newNetModDict{'majorSt'}, subjFCMat);
   % deal with minorSt
   fcMinor = calcSubjFC(newNetModDict{'minorSt'}, subjFCMat);
   res = py.dict(pyargs('majorSt', fcMajor, 'minorSt', fcMinor));
end

%goes through basinDictObject, reads the cor and anticor data and calculates FC.
function res = calcSubjFC(basinDict, subjFCMat);
  keys = basinDict.keys();
  res = py.dict(pyargs()); % which is to be filled.
  for jj = 1:length(keys);
     key = keys{jj}; 
     res{key} = py.dict(pyargs()); % to be filled.
     currDict = basinDict{key};
%% deal with correlated nets
     corrObj = currDict{'cor'};
     [res{key}{'cor'}, corModules] = calcFCFromObj(corrObj, subjFCMat);
%% deal with anticorrelated nets
     antiCorObj = currDict{'anticor'};
     [res{key}{'anticor'}, anticorModules] = calcFCFromObj(antiCorObj, subjFCMat);
%% calc the combined within and across FC,
     modules = [corModules anticorModules];
     [res{key}{'combined_withinFCMean'}, res{key}{'combined_acrossFCMean'}] = FCcalculator("notFilled", "notFilled", modules, subjFCMat);
  end
end

% dictObj is the deepest/last dict object in py.dict structure of NetsModsFC in `plotgenerator.m`
function [res, modules] = calcFCFromObj(dictObj, subjFCMat)
   res = deepCopyDict(dictObj);
   modules = {};
   modules{end+1} = res{'active'}; modules{end+1} = res{'inactive'};
   [withinFCMean, acrossFCMean] = FCcalculator("notFilled", "notFilled", modules, subjFCMat);
   res{'withinFCMean'} = withinFCMean;
   res{'acrossFCMean'} = acrossFCMean;
end

% get frequency of stateIndices passed from empirical data
function freqStates = getFreqOfStates(binarizedData, LocalMinIndx, BasinGrph, stateIndices);
	basinNums = getBasinNum(binarizedData, LocalMinIndx, BasinGrph);
	Dynamics{1} = mfunc_GetDynamics(basinNums, length(LocalMinIndx));
	freqStates = Dynamics{1}.Freq(stateIndices);
end

function basinNum = getBasinNum(binarizedData, LocalMinIndx, BasinGrph)
	StateNum = mfunc_GetStateNumber(binarizedData);
        basinNum = mfunc_GetBasinNumber(StateNum, BasinGrph, LocalMinIndx);
end

% get frequency of transitions. result = [freqDirectTrans freqIndirectTrans].
function result = getTransFreq(binarizedData, LocalMinIndx, BasinGrph, majorstateIndices);
	basinNums = getBasinNum(binarizedData, LocalMinIndx, BasinGrph);
	Dynamics{1} = mfunc_GetDynamics(basinNums, length(LocalMinIndx));
        ind1 = majorstateIndices(1); ind2 = majorstateIndices(2);
	directMajorTrans = Dynamics{1}.Dtrans(ind1, ind2) + Dynamics{1}.Dtrans(ind2, ind1);
	N = length(LocalMinIndx);
	directMinorTrans = getMinorStateTransition(Dynamics{1}.Dtrans, N, majorstateIndices);
	indirectTrans = calculateIndirectTransFreq(basinNums, majorstateIndices);
	result = [directMajorTrans directMinorTrans indirectTrans];
end

% get duration of stateIndices passed from empirical data
function durations = getDurationOfStates(binarizedData, LocalMinIndx, BasinGrph, stateIndices);
	basinNums = getBasinNum(binarizedData, LocalMinIndx, BasinGrph);
	majorStateDurationMap = computeDurationOfStates(basinNums, stateIndices);
	durations = mean(majorStateDurationMap(0));
end

function [LocalMinIndx, BasinGrph] = getLocalMinIndx(h, J);
	E = mfunc_Energy(h, J);
 	[LocalMinIndx, BasinGrph, ~] = mfunc_LocalMin(length(h), E);
end



