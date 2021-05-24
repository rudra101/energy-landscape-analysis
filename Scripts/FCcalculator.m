% modules contain the separated network modules subsequently to be used for calculating between and across FC. 
function [withinFCMean, acrossFCMean] = FCcalculator(group, age, modules, subjFCMat)
  
%% calculate within FC
  withinFC = [];
  for ii = 1:length(modules);
   nets = double(modules{ii}); % because calling this code with py.array class of objects
   val = calculateAvgBetwnFC(group, age, nets, subjFCMat);
   withinFC = [withinFC val];
  end
%% calculate across FC
  acrossFC = 0; 
  cnt = 0;
  for ii = 1:length(modules);
    for jj = ii+1:length(modules);
	  netI = double(modules{ii}); % to support smooth functioning with py.array class of objects
	  netJ = double(modules{jj});
	  % now, work on netI and netJ;
	  for xx = 1:length(netI);
	   for yy = 1:length(netJ);
	    cnt = cnt + 1;
            acrossFC = acrossFC + calculateAvgBetwnFC(group, age, [netI(xx), netJ(yy)], subjFCMat);
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

% if nets = [i j k...], then it calculates average FC value of all unique pairs of (i,j) across all subjects
% subjFCMat if provided will be used instead of the FC matrices of all members of the group.
function res = calculateAvgBetwnFC(group, age, nets, subjFCMat)
  global ASD TD;
  FCMatFlag = false; % flag for detecting if subjcMat has been provided
  if length(subjFCMat) == 0;
    FCMatrices = eval(sprintf('%s.%s.FCMatrices', group, age));
  else FCMatFlag = true;
  end
  res = 0; cnt = 0; %cnt will encode number of pairs.
  for ii = 1:length(nets);
   for jj = ii+1:length(nets);
       cnt = cnt + 1;
       subjectFCs = 0;
       if ~FCMatFlag; % custom FC mat obj not provided
	   for kk = 1:length(FCMatrices); % traverse each subjects FC matrix
	     FCMat = FCMatrices{kk};
	     subjectFCs = subjectFCs + FCMat(nets(ii), nets(jj));
	   end
	   subjectFCs = subjectFCs/length(FCMatrices); % find the average FC by dividing by num of subjects
       else % use the custom FC matrix provided for calculating the FC 
	   subjectFCs = subjectFCs + subjFCMat(nets(ii), nets(jj));
       end
       res = res + subjectFCs;
   end
  end
  if cnt ~= 0; res = res/cnt;
  else res = NaN;
  end
end


