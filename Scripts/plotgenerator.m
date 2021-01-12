%%below lines generated using Python code. Didn't know how to best handle these many data points across six groups.
%%eval can be used to mimic what is being done in Python.
for group = ["ASD", "TD"];
for age = ["child", "adolsc", "adult"];
eval(sprintf("datastruct = load('exactEzaki_%s_%s_MEM_results_10mm.mat');", lower(group),age));
for prop = ["h", "J", "rD", "r", "majorstateIndices", "majorStateDuration", "indirectTransFreq", "probN", "freq", "freqTrans", "basinSizePercent", "basinDurations","mean_basin_dur", "std_basin_dur"]; 
eval(sprintf('%s.%s.%s = datastruct.%s;', group, age, prop, prop));
end
end
end

%% plotting code begins.
%%(1) basin size for major states
majorStates = 1:2; labels = {};
for state = majorStates;
	labels{end+1} = sprintf('Major st %d', state);
end
%labels{end+1} = 'Minor st (grouped)';
%%between age groups
%for age = ["child", "adolsc", "adult"];
%	asd_minorstSize = 100 - sum(eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age)));
%	td_minorstSize = 100 - sum(eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))', age, age)));
%
%	asd_basinSzData = [eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age)) ; asd_minorstSize];
%	td_basinSzData = [eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))', age, age)); td_minorstSize];
%
%	asd_basinSzData = eval(sprintf('ASD.%s.basinSizePercent(ASD.%s.majorstateIndices(:))', age, age));
%	td_basinSzData = eval(sprintf('TD.%s.basinSizePercent(TD.%s.majorstateIndices(:))',age,age));
%
%	figure; bar(categorical(labels), [asd_basinSzData, td_basinSzData], 0.65, 'grouped');
%	legend(['ASD' ' ' char(age)], ['TD' ' ' char(age)],'Location','best');
%	ytickformat(gca, 'percentage');
%	ylabel('size of brain state');
%	if age == "child"; xlabel('children');
%	elseif age == "adolsc"; xlabel('adolescent');
%	elseif age == "adult"; xlabel('adult');
%	else xlabel('Not an expected age group');
%	end
%end
%%within a diagnostic group
%for group = ["ASD", "TD"];
%	for age = ["child", "adolsc", "adult"];
%		a = 100 - sum(eval(sprintf('%s.%s.basinSizePercent(%s.%s.majorstateIndices(:))', group, age, group, age)));
%		eval(sprintf('%s_minorStSize = a;', age));
%	end
%	basindataByAge = [];
%	for age = ["child", "adolsc", "adult"];
%	eval(sprintf('%s_basinSize =  [%s.%s.basinSizePercent(%s.%s.majorstateIndices(:)); %s_minorStSize];', age, group, age, group, age, age));
%	eval(sprintf('%s_basinSize = %s.%s.basinSizePercent(%s.%s.majorstateIndices(:));', age, group, age, group, age));
%	eval(sprintf('basindataByAge = [basindataByAge, %s_basinSize];', age));
%	end
%	figure; bar(categorical(labels), basindataByAge, 0.65, 'grouped');
%	legend([char(group) ' ' 'child'], [char(group) ' ' 'adolsc'], [char(group) ' ' 'adult'], 'Location', 'best');
%	ytickformat(gca, 'percentage');
%	ylabel('size of brain state');
%end
%%basin size of minor states (TBD)

%%duration of major states
%%between age groups
%labels = {'children', 'adolescent', 'adult'};
%initialisation of data fields
%for group = ["asd", "td"];
%  for prop = ["mean", "std"];
%   eval(sprintf('%s_%s_dur = [];', group, prop));
%  end
%end
%fill the group data
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
%%transition frequencies
%%direct transition between major states
%between groups
labels = {'child', 'adolescent', 'adult'};
%initialisation of data fields
for group = ["asd", "td"];
   eval(sprintf('%s_dirTrans = [];', group));
end
%fill the group data
for age = ["child", "adolsc", "adult"];
	for group = ["ASD", "TD"];
	transFreq = eval(sprintf('%s.%s.freqTrans', group, age));
	majorStIndices = eval(sprintf('%s.%s.majorstateIndices(:)',group, age));
	ind1 = majorStIndices(1); ind2 = majorStIndices(2);
	majorDirTrans = transFreq(ind1,ind2) + transFreq(ind2, ind1);
	eval(sprintf('%s_dirTrans = [%s_dirTrans, majorDirTrans];', lower(group), lower(group)));
	end
end
fig = figure; bar(categorical(labels), [asd_dirTrans(:), td_dirTrans(:)], 0.65, 'grouped');
legend('ASD', 'TD'); ylabel('Direct transition between major states')
set(gca,'xticklabel', labels);
%along age

%%indirect transition between multiple minor states


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


