% creates different files against each task, where each task defines a metric to be collected from empirical data.
function convertAndWriteforRplot(data, group, age, taskType, empiricalFlag)
global AGES FIQS ADOS_TOTAL ADOS_SOCIAL ADOS_RRB ADOS_COMM; % this follows the defn in binarizeCollateMultipleSiteDataForMEM.m

if nargin < 5;
	empiricalFlag = true;
end
	result = [];
	switch taskType
	case "freq_Combn"
	  for ii = 1:length(data)
	   result = [result; group, age, "majorSt_Combn", data(ii,1)]; %major state combined
	   result = [result; group, age, "minorSt_Combn", data(ii,2)]; %minor state combined
	  end
	  writeToCsv(result, "freqCombnR", empiricalFlag)	
	case "freq"
	  for ii = 1:length(data)
	   result = [result; group, age, "majorSt1", data(ii,1)]; %major state 1
	   result = [result; group, age, "majorSt2", data(ii,2)]; %major state 2
	   result = [result; group, age, "minorSt_Combn", data(ii,3)]; %minor state combined
	  end
	  writeToCsv(result, "freqR", empiricalFlag)
	case "trans" 
	  for ii = 1:length(data)
	   result = [result; group, age, "direct MajorTrans", data(ii,1)]; % direct major trans
	   result = [result; group, age, "direct MinorTrans", data(ii,2)]; % direct minor trans
	   result = [result; group, age, "indirect MajorTrans", data(ii,3)]; % indirect major->minor->major
	  end
	  writeToCsv(result, "transR", empiricalFlag)
        case "duration"
	  for ii = 1:length(data)
	   result = [result; group, age, data(ii,1)]; %mean basin duration
	  end
	  writeToCsv(result, "durationR", empiricalFlag)
	case "ageWriter"
	       for jj = 1:length(data);
		 folderInfo = data{jj};
		 folderName = folderInfo(1);
		 ageofSubs = AGES(folderName);
		 for ageInYear = ageofSubs;
		  result = [result; group, age, ageInYear]; % age of indiv subjects
		 end
		end
		writeToCsv(result, "ageWriterR", empiricalFlag);
	case "fiqWriter"  % write FIQs of indiv subjects
		for jj = 1:length(data);
		 folderInfo = data{jj};
		 folderName = folderInfo(1);
		 fiqofSubs = FIQS(folderName);
		 for fiq = fiqofSubs;
		  result = [result; group, age, fiq]; % FIQ of indiv subjects
		 end
		end
		writeToCsv(result, "fiqWriterR", empiricalFlag);
	case {"adosTotalWriter", "adosSocialWriter", "adosRRBWriter", "adosCommWriter"}
                for jj = 1:length(data);
		 folderInfo = data{jj};
		 folderName = folderInfo(1);
		 charred = char(taskType);
		 charred = upper(charred);
		 % please see "SECTION I" in `binarizeCollateMultipleSiteDataForMEM.m` to understand how following line behaves during `eval`. For ex: if taskType is `adosTotalWriter` then the map `ADOS_TOTAL` will be evaluated against each folderName (see Section I for map entries).
		 scoresOfSubs = eval(sprintf('%s_%s(folderName)', charred(1:4), charred(5:end-6)));
		 for adosScore = scoresOfSubs;
		  result = [result; group, age, adosScore]; % ADOS scores (as per taskType) of indiv subjects
		 end
		end
		writeToCsv(result, taskType, empiricalFlag);
	case "adosSocialWriter"
		for jj = 1:length(data);
		 folderInfo = data{jj};
		 folderName = folderInfo(1);
		 adosSocialofSubs = ADOS_SOCIAL(folderName);
		 for ados_social = adosSocialofSubs;
		  result = [result; group, age, ados_social]; % ADOS total of indiv subjects
		 end
		end
		writeToCsv(result, "adosSocialWriterR", empiricalFlag);
        case "netModsWriter" % this also writes the difference between within and across FC for each subject. Quite overloaded, but can't think of a beautiful way to implement this.
	     resultGap = [];
	     for jj = 1:length(data); %array of python dict. For each subject, extracts the data from minor and major state modules and creates data structure for writing.
                 pydict = data{jj};
		 % deal with major state 
		 currObj = pydict{'majorSt'};
		 [resMajor,resMajorGap] = helperForFCWrite(group, age, "majorSt", currObj, "majorSt");
		 % deal with minor state
		 currObj = pydict{'minorSt'};
		 [resMinor,resMinorGap] = helperForFCWrite(group, age, "minorSt", currObj, "minorSt");
		 result = [result; resMajor; resMinor];
		 resultGap = [resultGap; resMajorGap; resMinorGap];
	     end
	     
	     writeToCsv(result, "netModsWriterR", empiricalFlag); %writer for across, within FCs
	     writeToCsv(resultGap, "netModsGapR", empiricalFlag); %writer for within `minus` across FC.
        otherwise
	  error(sprintf('taskType %s not recognized', taskType))
	end
end

% returns an individual subject's (a) within FC, (b) across FC values for a stateType
% (c) within `minus` across FC's value (i.e; the gap between within and across FC) 
function [result, resultGap] = helperForFCWrite(group, age, stateType, pydict, prefix)
    suffixAppend = true;
    if contains(prefix, 'major'); %no need to append keys for major state
     suffixAppend = false;
    end
    result = []; % contains the individal across and FC values
    resultGap= []; % contains the diff of within and across FC.
    keys = pydict.keys();
    for ii = 1:length(keys);
      key = keys{ii};
      val = pydict{key};
      if suffixAppend;
	statename = strcat(stateType, "_", char(key));
      else
	statename = stateType;
      end
      withinFC = pydict{key}{'combined_withinFCMean'};
      acrossFC = pydict{key}{'combined_acrossFCMean'};
      result = [result; group age "across" statename acrossFC];
      result = [result; group age "within" statename withinFC];
      resultGap = [resultGap; group age "within-across" statename (withinFC - acrossFC)];
    end
end

