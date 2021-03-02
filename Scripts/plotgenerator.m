%%eval can be used to set these many data points.
global ASD TD;
%for group = ["ASD", "TD"];
%for age = ["child", "adolsc", "adult"];
%    % MEM results
%    eval(sprintf("datastruct = load('exactEzaki_%s_%s_MEM_results_10mm.mat');", lower(group),age));
%    % FC matrices of indiv subjects in a group
%    eval(sprintf("FCstruct = load('exactEzaki_%s_%s_FCMatrices_10mm.mat');", lower(group),age));
%    % set FCMatrices of individual subjects
%    eval(sprintf('%s.%s.FCMatrices = FCstruct.FCMatrices;', group, age));
%    for prop = ["h", "J", "rD", "r", "majorstateIndices", "LocalMinIndex",  "majorStateDuration", "indirectTransFreq", "probN", "freq", "freqTrans", "freqDirectTrans", "basinSizePercent", "basinDurations","mean_basin_dur", "std_basin_dur"]; 
%      %set MEM results
%      eval(sprintf('%s.%s.%s = datastruct.%s;', group, age, prop, prop));
%    end
%end
%end
%% summarize correlated and anti-correlated modules in minor and major states of the subjects
%group = "TD";
%age = "adolsc";
for group = ["ASD", "TD"];
for age = ["child", "adolsc", "adult"];
   majorStIndx = eval(sprintf('%s.%s.majorstateIndices', group, age));
   localMinIndx = eval(sprintf('%s.%s.LocalMinIndex', group, age)); 
   pydict = generateNetworkModules(group, age, localMinIndx, majorStIndx);
   eval(sprintf('%s.%s.corAntiCorMods = pydict;', group, age)); %set cor AntiCor Mods
   % now, calculate within and across FC vals for empirical subjects based on model information
   pydictMajor = generateFCvalsForModules(group, age, localMinIndx, pydict{'major st'});
   pydictMinor = generateFCvalsForModules(group, age, localMinIndx, pydict{'minor st'});
%% generate figures for major state comparison
   %createPatternsForComparisons(group, age, pydictMajor, 'majorSt')
%% generate figures for minor state comparison
   %createPatternsForComparisons(group, age, pydictMinor, 'minorSt')
   %close all; %close figures
   % pydict with both pydict info
   pydict = py.dict(pyargs('majorSt', pydictMajor, 'minorSt', pydictMinor));
   %% set the pydict
   eval(sprintf('%s.%s.NetModsWithFC = pydict;', group, age)); %set FC vals for network modules 
end
end

%for group = ["ASD", "TD"];
%for age = ["child", "adolsc", "adult"];
%   pydict = eval(sprintf('%s.%s.NetModsWithFC;', group, age)); %get FC vals for network modules
%   majorPydct = pydict{'majorSt'};
%   minorPydct = pydict{'minorSt'};
%   prefix = [char(group) ' ' char(age) ' '];
%   printWithinAcrossFCInfo(majorPydct, [prefix 'major st']);
%   printWithinAcrossFCInfo(minorPydct, [prefix 'minor st']);
%end
%end

%%summarize the basin duration data - custom
%fprintf('--------------------\n');
%fprintf('Basin duration stats\n');
%for group = ["ASD", "TD"];
%for age = ["child", "adolsc", "adult"];
%	fprintf('--------------------\n');
%	fprintf('Stats for %s %s\n', group, age);
%	eval(sprintf('majorStIndx = %s.%s.majorstateIndices', group, age));
%	eval(sprintf('basinNum = length(%s.%s.freq);', group, age));
%	eval(sprintf('basinDur = %s.%s.basinDurations;', group, age));
%	for ii = 1:basinNum;
%	eval(sprintf('mean_dur = %s.%s.mean_basin_dur(%d);', group, age, ii));
%	eval(sprintf('std_dur = %s.%s.std_basin_dur(%d);', group, age, ii));
%	fprintf('basin %d duration: %f ± %f\n', ii, mean_dur, std_dur);
%	end
%end
%end

%% plotting code begins.
%%basin sizes of states
%% export the data to R
%formatModelDataAndExportToFileForR("basinSize")

%%(1) basin size for major states
%majorStates = 1:2; labels = {};
%for state = majorStates;
%	labels{end+1} = sprintf('Major st %d', state);
%end
%labels{end+1} = 'Minor st (grouped)';
%asd_basinSzDataByAge = []; td_basinSzDataByAge = [];
%%%between age groups
%for age = ["child", "adolsc", "adult"];
%	asd_minorstSize = 100 - sum(eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age)));
%	td_minorstSize = 100 - sum(eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))', age, age)));
%
%	asd_basinSzData = [eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age)) ; asd_minorstSize];
%	td_basinSzData = [eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))', age, age)); td_minorstSize];
%%	asd_basinSzData = eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age));
%%	td_basinSzData = eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))',age,age));
%
%	fig = figure; bar(categorical(labels), [asd_basinSzData, td_basinSzData], 0.65, 'grouped');
%	legend(['ASD' ' ' char(age)], ['TD' ' ' char(age)],'Location','northeast');
%	ytickformat(gca, 'percentage');
%	ylabel('size of brain state');
%	if age == "child"; xlabel('children');
%	elseif age == "adolsc"; xlabel('adolescent');
%	elseif age == "adult"; xlabel('adult');
%	else xlabel('Not an expected age group');
%	end
%	[chisquare, p] = chi2test(asd_basinSzData, td_basinSzData);
%	title(sprintf('X^{2} = %f, p = %f', chisquare, p));
%	%customSaveFigure(fig, ['asd_td_' char(age)], 'basin_size');
%	close all;
%	asd_basinSzDataByAge = [asd_basinSzDataByAge, asd_basinSzData];
%	td_basinSzDataByAge =  [td_basinSzDataByAge, td_basinSzData];
%end
%
%%%within a diagnostic group. Same labels as above
%for group = ["TD"];
%%for group = ["ASD", "TD"];
%  childdata   = eval(sprintf('%s_basinSzDataByAge(:,1)', lower(group)));
%  adolscdata  = eval(sprintf('%s_basinSzDataByAge(:,2)', lower(group)));
%  adultdata   = eval(sprintf('%s_basinSzDataByAge(:,3)', lower(group)));
%  %first, plot between child and adolsc
%  basinSizeComparerAndPlotter(childdata, adolscdata, 'child', 'adolsc', group, labels);
%  %second, plot between adolsc and adult 
%  basinSizeComparerAndPlotter(adolscdata, adultdata, 'adolsc', 'adult', group, labels);
%  %third, plot between child and adult
%  basinSizeComparerAndPlotter(childdata, adultdata, 'child', 'adult', group, labels);
%end
%%basin size of minor states (TBD)

%%duration of major states
%% export the data to R
%formatModelDataAndExportToFileForR("duration")


%%between age groups
%labels = {'children', 'adolescent', 'adult'};
%%initialisation of data fields
%for group = ["asd", "td"];
%  for prop = ["mean", "std"];
%   eval(sprintf('%s_%s_dur = [];', group, prop));
%  end
%end
%%fill the group data
%for age = ["child", "adolsc", "adult"];
%	for group = ["ASD", "TD"];
%	stateDuration = eval(sprintf('%s.%s.majorStateDuration', group, age));
%	a_mean = mean(stateDuration);
%	a_std  = std(stateDuration);
%	eval(sprintf('%s_mean_dur = [%s_mean_dur, a_mean];', lower(group), lower(group)));
%	eval(sprintf('%s_std_dur = [%s_std_dur, a_std];', lower(group), lower(group)));
%	end
%end
%fig = figure; bar([asd_mean_dur(:), td_mean_dur(:)], 0.65, 'grouped');
%hold on;
%mean_seq = [asd_mean_dur(:)  td_mean_dur(:)];
%std_seq = [asd_std_dur(:)  td_std_dur(:)];
%plotErrorbar(mean_seq, std_seq);
%legend('ASD', 'TD'); ylabel('duration of major states')
%set(gca,'xticklabel', labels);
%%apply two-sample t-test for two groups
%for age = ["child", "adolsc", "adult"];
% asd_data = eval(sprintf('ASD.%s.majorStateDuration', age));
% td_data = eval(sprintf('TD.%s.majorStateDuration', age));
% [h, p, ~, stats] = ttest2(asd_data, td_data);
% fprintf('ASD vs TD %s. h = %f, t = %f , p = %f , df = %f\n', age, h, stats.tstat, p, stats.df);
%end
%hold off;
%%% duration (major states) within a diagnostic group
%data_mean = [asd_mean_dur ; td_mean_dur];
%data_std = [asd_std_dur ; td_std_dur];
%labels = {'ASD', 'TD'};
%fig = figure; bar(data_mean, 0.65, 'grouped');
%hold on;
%plotErrorbar(data_mean, data_std);
%legend({'child', 'adolescent', 'adult'}); ylabel('duration of major states')
%set(gca,'xticklabel', labels);
%%two-sample t-test within each diagnostic group
%for group = ["ASD", "TD"];
%  childdata   = eval(sprintf('%s.child.majorStateDuration', group));
%  adolscdata  = eval(sprintf('%s.adolsc.majorStateDuration', group));
%  adultdata   = eval(sprintf('%s.adult.majorStateDuration', group));
%  %first, compare between child and adolsc
%  basinDurationComparer(childdata, adolscdata, 'child', 'adolsc', group);
%  %second, compare between adolsc and adult 
%  basinDurationComparer(adolscdata, adultdata, 'adolsc', 'adult', group);
%  %third, compare between child and adult
%  basinDurationComparer(childdata, adultdata, 'child', 'adult', group);
%end
%%transition frequencies
%transitionPlotter("directMajor"); %direct trans betwn major states
%transitionPlotter("directMinor"); %direct trans betwn minor states
%transitionPlotter("indirectMajor"); %indirect trans betwn major states
%%export trans_data to R format.
%formatModelDataAndExportToFileForR("trans")
%%export appearance frequency to R
%formatModelDataAndExportToFileForR("freq")

%%empirical data measures (remember it can be done more intuitively in R.)
%%basin frequencies during random walk
%%please generate {asd,td}_{child,adolsc,adult}_freqs matrices where each row contain freq of {major st 1, major st2, combined minor sts} using code in binarizeCollateMultipleSiteDataForMEM.m
%generate between groups
%cnt = 1; %index for data
%for age = ["child", "adolsc", "adult"];
%	%major state1
%	asd_data = eval(sprintf('asd_%s_freqs(:,1);', age));
%	td_data = eval(sprintf('td_%s_freqs(:,1);', age));
%	majorSt1 = 100*[asd_data; td_data];
%	grp = [repmat(strcat("ASD ", age), length(asd_data), 1); repmat(strcat("TD ", age), length(td_data), 1);];
%	boxPlotsForAppearFreq(majorSt1, grp, 'Major st #1', age, 100*asd_data, 100*td_data);
%	%major state2
%	asd_data = eval(sprintf('asd_%s_freqs(:,2);', age));
%	td_data = eval(sprintf('td_%s_freqs(:,2);', age));
%	majorSt2 = 100*[asd_data; td_data];
%	grp = [repmat(strcat("ASD ", age), length(asd_data), 1); repmat(strcat("TD ", age), length(td_data), 1);];
%	boxPlotsForAppearFreq(majorSt2, grp, 'Major st #2', age, 100*asd_data, 100*td_data);
%	%combined state
%	asd_data = eval(sprintf('asd_%s_freqs(:,3);', age));
%	td_data = eval(sprintf('td_%s_freqs(:,3);', age));
%	minorSt = 100*[asd_data; td_data];
%	grp = [repmat(strcat("ASD ", age), length(asd_data), 1); repmat(strcat("TD ", age), length(td_data), 1);];
%	boxPlotsForAppearFreq(minorSt, grp, 'Minor st (combined)', age,  100*asd_data, 100*td_data);
%end

% netModDict is a python dict
function printWithinAcrossFCInfo(netModDict, printMsg)
  fprintf('----------------\n');
  fprintf(sprintf('Printing. %s.\n', printMsg))
  fprintf('----------------\n');
  keys = netModDict.keys();
  for ii = 1:py.len(keys);
     key = keys{ii};
     acrossFC = double(netModDict{key}{'combined_acrossFCMean'});
     withinFC = double(netModDict{key}{'combined_withinFCMean'});
     fprintf(sprintf('Comparing basins %s on averages. Across FC: %f. Within FC: %f. <Within> - <Across> = %f.\n', char(key), acrossFC, withinFC, withinFC - acrossFC));
  end
end

function formatModelDataAndExportToFileForR(taskType)
global ASD TD;
	switch taskType
	case "trans"
		result = []; data = zeros(1,3);
		commonTransName = ["direct MajorTrans" "direct MinorTrans" "indirect MajorTrans"];
		for age = ["child", "adolsc", "adult"];
		for group = ["ASD", "TD"];
		 common_array = repmat([group, age], 3, 1);
		 majorStIndices = eval(sprintf('%s.%s.majorstateIndices(:)',group, age));
		 transFreq = eval(sprintf('%s.%s.freqDirectTrans', group, age));
		 ind1 = majorStIndices(1); ind2 = majorStIndices(2);
		 data(1) = transFreq(ind1,ind2) + transFreq(ind2, ind1); %directMajor trans
		 N = size(transFreq, 1); %N is num of basins.
		 data(2) = getMinorStateTransition(transFreq, N, majorStIndices); %directMinor trans
		 data(3) = eval(sprintf('%s.%s.indirectTransFreq', group, age)); %indirect MajorTrans
		 toAppend = [common_array, commonTransName(:), data(:)]; %consult the format in under "trans" in convertAndWriteforRplot.m
		 result = [result; toAppend];
		end
		end
		writeToCsv(result, "transR", false);
	case "duration"
		result = [];
		for age = ["child", "adolsc", "adult"];
		for group = ["ASD", "TD"];
		stateDuration = eval(sprintf('%s.%s.majorStateDuration', group, age));
		a_mean = mean(stateDuration);
		a_std  = std(stateDuration);
		toAppend = [group age a_mean a_std];
		result = [result; toAppend];
		end
		end
		writeToCsv(result, "durationR", false);
	case "basinSize"
		result = []; data = zeros(1,3);
		commonBasinName = ["Major st 1" "Major st 2" "Minor st (grouped)"];
		for age = ["child", "adolsc", "adult"];
		for group = ["ASD", "TD"];
		common_array = repmat([group, age], 3, 1);
		majorStIndices = eval(sprintf('%s.%s.majorstateIndices(:)',group, age));
		majorStSize =  eval(sprintf('%s.%s.basinSizePercent(majorStIndices)', group, age));
		minorStSize = 100 - sum(majorStSize);
		szdata = [majorStSize' minorStSize];
		toAppend = [common_array, commonBasinName(:), szdata(:)];
		result = [result; toAppend];
		end
		end
		writeToCsv(result, "basinSizeR", false);
	case "freq"
		result = []; data = zeros(1,3);
		commonBasinName = ["Major st 1" "Major st 2" "Minor st (grouped)"];
		for age = ["child", "adolsc", "adult"];
		for group = ["ASD", "TD"];
		common_array = repmat([group, age], 3, 1);
		majorStIndices = eval(sprintf('%s.%s.majorstateIndices(:)',group, age));
		majorStFreq = eval(sprintf('%s.%s.freq(majorStIndices)', group, age));
		minorStFreq = 1 - sum(majorStFreq);
		freqdata = [majorStFreq minorStFreq];
		toAppend = [common_array, commonBasinName(:), freqdata(:)];
		result = [result; toAppend];
		end
		end
		writeToCsv(result, "freqR", false);
	otherwise
	   error(sprintf('taskType %s not recognised', taskType))
	end
end

% a general function to plot direct and indirect trans freq for major states, and direct trans freq for minor states. 
%taskType encodes the information - a) directMajor, b) indirectMajor c) directMinor
function result = transitionPlotter(taskType)
global ASD TD;
%%between groups
	%initialisation of data fields
	for group = ["asd", "td"];
	   eval(sprintf('%s_trans = [];', group));
	end
	%fill the group data
	for age = ["child", "adolsc", "adult"];
		for group = ["ASD", "TD"];
			majorStIndices = eval(sprintf('%s.%s.majorstateIndices(:)',group, age));
			transFreq = eval(sprintf('%s.%s.freqDirectTrans', group, age));
			ind1 = majorStIndices(1); ind2 = majorStIndices(2);
			switch taskType
			case "directMajor"
			   result = transFreq(ind1,ind2) + transFreq(ind2, ind1);
			case "directMinor"
			   N = size(transFreq, 1); %N is num of basins.
			   result = getMinorStateTransition(transFreq, N, majorStIndices);
			case "indirectMajor"
			  result = eval(sprintf('%s.%s.indirectTransFreq', group, age));
			otherwise
			  error(sprintf("cannot recognise %s task", taskType))
			end
		eval(sprintf('%s_trans = [%s_trans, result];', lower(group), lower(group)));
		end
	end
	labels = {'child', 'adolescent', 'adult'};
	steps = 100; %because trans freq is plotted in percentage
	fig = figure; bar(steps*[asd_trans(:), td_trans(:)], 0.65, 'grouped');
	legend('ASD', 'TD'); 
	set(gca,'xticklabel', labels);
	ytickformat(gca, 'percentage');
	switch taskType
	case "directMajor"
	  ylabel('Direct trans freq between major states')
	case "indirectMajor"
	  ylabel('Indirect trans freq between major states')
	case "directMinor"
	  ylabel('Direct trans freq between minor states')
	end
%% save the figure
	customSaveFigure(fig, ['trans_acrossAgeBetwnGroup_'] , taskType);
%% run chi-square tests between diagnostic groups along age
	%run chi-square test for direct transition.
	fprintf('Chi-square test for task %s\n', taskType);
	for ii = 1:3;
		n1 = asd_trans(ii); n2 = td_trans(ii); 
		%[chisquare, p] = chi2test([n1; 1-n1], [n2; 1-n2]); %unpooled
		n1 = n1 * steps; n2 = n2 * steps; 
		[chi2, p2] = chi2testSingle(n1, steps, n2, steps); %pooled
		%[chisquarePower, p_Power] = chi2test([n1; (10^5)-n1], [n2; (10^5)-n2]) %unpooled
		%fprintf('chisquare = %f, p = %f\n', chisquare, p);
		%fprintf('chisquare = %f, p = %f | chi2 = %f, p= %f\n', chisquare, p, chi2, p2);
		%p2
		fprintf('ASD vs TD %s. chi2 = %f, p= %f\n', labels{ii}, chi2, p2);
	end
%%along age
	labels = {'ASD', 'TD'};
	fig = figure; bar(steps*[asd_trans; td_trans], 0.65, 'grouped');
	legend('child', 'adolescent', 'adult');
	set(gca,'xticklabel', labels); 
	ytickformat(gca, 'percentage');
	switch taskType
	case "directMajor"
	  ylabel('Direct trans freq between major states')
	case "indirectMajor"
	  ylabel('Indirect trans freq between major states')
	case "directMinor"
	  ylabel('Direct trans freq between minor states')
	end
%%save the figure
	customSaveFigure(fig, ['trans_acrossAgeWithinGroup_'] , taskType);
%%run chi-test for age divisions within a diagnostic group
	for group = ["ASD", "TD"];
		childdata =  eval(sprintf('%s_trans(1)', lower(group)));
		adolscdata =  eval(sprintf('%s_trans(2)', lower(group)));
		adultdata = eval(sprintf('%s_trans(3)', lower(group)));
		%first, compare between child and adolsc
		transComparer(childdata, adolscdata, steps, 'child', 'adolsc', group);
		%second, compare between adolsc and adult 
		transComparer(adolscdata, adultdata, steps, 'adolsc', 'adult', group);
		%third, compare between child and adult
		transComparer(childdata, adultdata, steps, 'child', 'adult', group);
	end
	fprintf('--------------------\n');
	result = [asd_trans; td_trans];
end

%%TBD: rewrite this function to preserve beauty. (or figure out a way to do in R.)
function boxPlotsForAppearFreq(data, grp, label, age, data1, data2)
fig = figure; boxplot(data, grp);
%set(gca, 'xticklabels', {'ASD, TD'});
ytickformat(gca, 'percentage');
xlabel(label); ylabel('appearance freq (empirical)');
[h, p, ~, stats] = ttest2(data1, data2);
 fprintf('(%s) %s (ASDvs TD). h = %f, t = %f , p = %f , df = %f\n', label, age, h, stats.tstat, p, stats.df);
customSaveFigure(fig, ['asd_td_' label '_' char(age)] , 'empirical_freq'); 
end

function transComparer(data1, data2, steps, prop_data1, prop_data2, group)
 [chi2square, p] = chi2testSingle(data1*steps, steps, data2*steps, steps);
 fprintf('(%s) %s vs %s. chi2square = %f, p = %f\n', group, prop_data1, prop_data2, chi2square, p);
end

%as of now, runs t-test only. have to figure how to plot.
function basinDurationComparer(data1, data2, prop_data1, prop_data2, group)
 [h, p, ~, stats] = ttest2(data1, data2);
 fprintf('(%s) %s vs %s. h = %f, t = %f , p = %f , df = %f\n', group, prop_data1, prop_data2, h, stats.tstat, p, stats.df);
end

function fig = basinSizeComparerAndPlotter(data1, data2, prop_data1, prop_data2, group, labels)
  fig = figure; bar(categorical(labels), [data1, data2], 0.65, 'grouped');
  ytickformat(gca, 'percentage');
  location = 'northeast';
  if group == "TD"; location = 'best';
  end
  legend([char(group) ' ' prop_data1], [char(group) ' ' prop_data2], 'Location', 'northeast');
  xlabel([char(prop_data1) ' vs ' char(prop_data2) ' (' char(group) ')']); ylabel('size of brain state');
  [chisquare, p] = chi2test(data1, data2);
  title(sprintf('X^{2} = %f, p = %f', chisquare, p));
  customSaveFigure(fig, group, [prop_data1 '_' prop_data2 '_basinSz']);
end

function customSaveFigure(fig, group, property)
        %prefix = '(exact Ezaki)'; 
        filename = [char(group) '_' char(property)];
	saveas(fig, filename, 'jpg');
end

%pooled version of chi-square or z-test. Refer to NPSS' PASS documentation stored on system
function [chi2square, p] = chi2testSingle(n1, N1, n2, N2)
%from https://in.mathworks.com/matlabcentral/answers/96572-how-can-i-perform-a-chi-square-test-to-determine-how-statistically-different-two-proportions-are-in
       % Pooled estimate of proportion
       p0 = (n1+n2) / (N1+N2);
       % Expected counts under H0 (null hypothesis)
       n1_0 = N1 * p0;
       n2_0 = N2 * p0;
       % Chi-square test, by hand
       observed = [n1 N1-n1 n2 N2-n2];
       expected = [n1_0 N1-n1_0 n2_0 N2-n2_0];
       chi2square = sum((observed-expected).^2 ./ expected);
       p = 1 - chi2cdf(chi2square,1);
end

%Matlab doesn't support direct comparison of proportions, this implements chi-square test between two row or column vectors.
% the degree of freedom is treated as len(vector) - 1.
function [chisquare, p] = chi2test(observed_data, expected_data);  
	obs_len = length(observed_data); exp_len = length(expected_data);
	if obs_len ~= exp_len;
		error(sprintf('Expected and observed data are of different length'));
	end
	chisquare = 0;
	for ii = 1:obs_len;
	chisquare = chisquare + (observed_data(ii) - expected_data(ii))^2 / expected_data(ii) ;
	end
	p = 1-chi2cdf(chisquare, obs_len - 1);
end
function plotErrorbar(main_val, err_val);
	[ngroups, nbars] = size(main_val);
	groupwidth = min(0.8, nbars/(nbars + 1.5));
	% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
	for ii = 1:nbars;
	    % Calculate center of each bar
	    x = (1:ngroups) - groupwidth/2 + (2*ii-1) * groupwidth / (2*nbars);
	    errorbar(x, main_val(:,ii), err_val(:,ii), 'k', 'linestyle', 'none');
	end
end

%%frequency of occupancy from random walk
%%between age groups
%for age = ["child", "adolsc", "adult"];
%	asd_minorstFreq = 100 - sum(eval(sprintf('ASD.%s.freq(ASD.%s.majorstateIndices(:))', age, age)));
%	td_minorstFreq = 100 - sum(eval(sprintf('TD.%s.freq(TD.%s.majorstateIndices(:))', age, age)));
%
%	asd_basinFreq = [eval(sprintf('ASD.%s.freq(ASD.%s.majorstateIndices(:))', age, age)) ; asd_minorstFreq];
%	td_basinFreq = [eval(sprintf('TD.%s.freq(TD.%s.majorstateIndices(:))', age, age)); td_minorstFreq];
%
%	figure; bar(categorical(labels), [asd_basinFreq, td_basinFreq], 0.65, 'grouped');
%	legend(['ASD' ' ' char(age)], ['TD' ' ' char(age)],'Location','best');
%	ytickformat(gca, 'percentage');
%	ylabel('freq of brain state');
%	if age == "child"; xlabel('children');
%	elseif age == "adolsc"; xlabel('adolescent');
%	elseif age == "adult"; xlabel('adult');
%	else xlabel('Not an expected age group');
%	end
%end
%%within a diagnostic group
%for group = ["ASD", "TD"];
%	for age = ["child", "adolsc", "adult"];
%		a = 100 - sum(eval(sprintf('%s.%s.freq(%s.%s.majorstateIndices(:))', group, age, group, age)));
%		eval(sprintf('%s_minorStFreq = a;', age));
%	end
%	basindataByAge = [];
%	for age = ["child", "adolsc", "adult"];
%	eval(sprintf('%s_basinFreq =  [%s.%s.freq(%s.%s.majorstateIndices(:)); %s_minorStFreq];', age, group, age, group, age, age));
%	eval(sprintf('basindataByAge = [basindataByAge, %s_basinFreq];', age));
%	end
%	basindataByAge;
%	figure; bar(categorical(labels), basindataByAge, 0.65, 'grouped');
%	legend([char(group) ' ' 'child'], [char(group) ' ' 'adolsc'], [char(group) ' ' 'adult'], 'Location', 'best');
%	ytickformat(gca, 'percentage');
%	ylabel('freq of brain state');
%end


