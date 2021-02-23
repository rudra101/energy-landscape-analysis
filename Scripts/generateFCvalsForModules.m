% this function takes a python dict `corAntiCorDict` where each key is of the form 'index1-index2' and vals contain `cor` and `anticor` where the network indices in a pattern are mentioned.
% thus, the function also takes as an input -
% (a) `localMinIndx` to figure out the minima being considered using the keys of the struct.
% outputs - python dict where each key passed in the input `corAntiCorStruct` has the vals
% (a) moduleDivisions - for each key the modules that were considered. A cell array.
% (b) mean of within module FCs for all empirical subjects
% (c) mean of across module FCs for all empirical subjects 
function FCDict = generateFCvalsForModules(group, age, localMinIndx, corAntiCorDict);
  keys = keys(corAntiCorDict); %get keys of the python dict
  valCell = {};
  for ii = 1:py.len(keys);
      key = char(keys{ii});
      corIndices = int8(corAntiCorDict{key}{'cor'});
      anticorIndices = int8(corAntiCorDict{key}{'anticor'});
      basinIndices = [int8(key(1) - '0') int8(key(3) - '0')]; % decode the key to its minima indices
      resDict = differentiateModulesCalcFC(group, age, localMinIndx, basinIndices, corIndices, anticorIndices);
      % make an array of python dict to use later.
      valCell{end+1} = resDict;
  end
 % create the payload for python dict. TO be used in eval.
 argStr = '';
 for ii = 1:py.len(keys);
    key = char(keys{ii});
    % trying to reproduce "'key', inputDict('key')" to use as pyargs
    argStr = [argStr ',' getSingleQuote() key getSingleQuote sprintf(', valCell{%d}', ii) ]
 end
 argStr = ['pyargs(' argStr(2:end) ')']; % remove the first comma from argStr
 FCDict = eval(sprintf('py.dict(%s)', argStr));
end

% the output will be of the form - {'cor': ['active': [roilist...], 'inactive': [roilist..], 'withinFCMean': , 'acrossFCMean': },
%                              'anticor': ['active': [roilist..], 'inactive': [roilist..], 'withinFCMean': , 'acrossFCMean': }
%                             'combined_withinFCMean': , 'combined_acrossFCMean':  }
function differentiateModulesCalcFC(group, age, localMinIndx, basinIndices, corrIndices, anticorIndices);
 pattern1 = dec2bin(localMinIndx(basinIndices(1)) - 1, 7);  %find the binary pattern
 pattern2 = dec2bin(localMinIndx(basinIndices(2)) - 1, 7);  %find the binary pattern
%% first separate correlated indices into active and inactive networks. We will try to calculate mean FCs here also.
 [corr_withinFCMean, corr_acrossFCMean, corr_modules, corr_summaryDict] = getModulesWithMeanAcrossAndWithinFC(group, age, corrIndices, pattern1); 
%% then separate anti-correlated indices into active and inactive networks. We will try to calculate mean FCs here also.
 [anticor_withinFCMean, anticor_acrossFCMean, anticor_modules, anticor_summaryDict] = getModulesWithMeanAcrossAndWithinFC(group, age, anticorIndices, pattern1); 
%% now, calculate mean FCs (within and across) along all network divisions in both cor and anticor groups 
 [combn_withinFCMean, combn_acrossFCMean] = FCcalculator(group, age, [corr_modules anticor_modules]);
% create the final python dict
 res = py.dict(pyargs('cor', corr_summaryDict, 'anticor', anticor_summaryDict, 'combined_withinFCMean', combn_withinFCMean, 'combined_acrossFCMean', combn_acrossFCMean));
end

% segregates binary digits speficied by `indices` in `pattern` and calculates FC within and across
function [withinFCMean, acrossFCMean, modules, summaryDict] = getModulesWithMeanAcrossAndWithinFC(group, age, indices, pattern)
 roilist = ["DMN", "FPN", "SAN", "ATN", "SMN", "Auditory", "Visual"]; % left to right labels of binarised statenumber. Refer pg 6 of users_guide.pdf under Ezaki's energy-landscape-analysis folder
 activeInd = indices(pattern1(indices) == '1');
 inactiveInd = indices(pattern1(indices) == '0');
 activeNets = roilist(activeInd); inactiveNets = roilist(inactiveInd);
 modules = {}; % create payload for FCcalculator()
 modules{end+1} = activeInd; modules{end+1} = inactiveInd;
 [withinFCMean, acrossFCMean] = FCcalculator(group, age, modules);
 % create a python dict now
 summaryDict = py.dict(pyargs('active', activeNets, 'inactive', inactiveNets, 'withinFCMean', withinFCMean, 'acrossFCMean', acrossFCMean));
end

% modules contain the separated network modules for calculating between and across FC. 
function [withinFCMean, acrossFCMean] = FCcalculator(group, age, modules)
%% calculate within FC
  withinFC = [];
  for ii = 1:length(modules);
   nets = modules{ii};
   val = calculateAvgBetwnFC(group, age, nets);
   withinFC = [withinFC val];
  end
%% calculate across FC
  acrossFC = 0; 
  cnt = 0;
  for ii = 1:length(modules);
    for jj = i+1:length(modules);
	  netI = modules{ii};
	  netJ = modules{jj};
	  % now, work on netI and netJ;
	  for xx = 1:length(netI);
	   for yy = 1:length(netJ);
	    cnt = cnt + 1;
            acrossFC = acrossFC + calculateAvgBetwnFC(netI(xx), netJ(yy));
	   end
	  end
    end
  end
  % finally, set the results
  withinFCMean = nanmean(withinFC); %ignore the NaN
  if cnt ~= 0; acrossFCMean = acrossFC/cnt;
  else acrossFCMean = NaN;
  end
   
end

% if nets = [i j k...], then it calculates average FC value of all possible pairs of (i,j) across all subjects;
function res = calculateAvgBetwnFC(group, age, nets)
  global ASD TD;
  FCMatrices = eval('%s.%s.FCMatrices', group, age);
  res = 0; cnt = 0; %cnt will encode number of pairs.
  for ii = 1:length(nets);
   for jj = ii+1:length(nets);
       cnt = cnt + 1;
       subjectFCs = 0;
       for kk = 1:length(FCMatrices);
	  FCMat = FCMatrices{kk};
	  subjectFCs = subjectFCs + FCMat(nets(ii), nets(jj));
       end
       subjectFCs = subjectFCs/length(FCMatrices); % find the average FC
       res = res + subjectFCs;
   end
  end
  if cnt ~= 0; res = res/cnt;
  else res = NaN;
end

