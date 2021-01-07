exactEzakiPath = '/home/vinsea/Downloads/Exact Ezaki steps/';
GSRPath = '~/Downloads/GSR_Timeseries/';
noGSRPath = '~/Downloads/Without GSR Timeseries/';
%group = 'asd_child';
%group = 'asd_adolsc';
%group = 'asd_adult';
%group = 'td_child';
group = 'td_adolsc';
%group = 'td_adult';
diaggroup = group;
%for diaggroup = ["asd_child", "asd_adolsc", "asd_adult", "td_child", "td_adolsc", "td_adult"];
%for flag = [0 1 2]; % 0 - no GSR, 1 - GSR, 2 - Exact Ezaki.
	sphereRadius = 10;
        flag = 2;
	if flag == 0; filepath = sprintf('%s%s_collated.dat',GSRPath, diaggroup)
	elseif flag == 1; filepath = sprintf('%s%s_collated.dat',noGSRPath, diaggroup)
	elseif flag == 2; filepath = sprintf('%s%s_collated_%dmm.dat', exactEzakiPath, diaggroup, sphereRadius) 
	end
%	group = convertStringsToChars(diaggroup);
%%TBD: load data for variables instead of computing below if the file already exist.
	nodeNumber= 7; initCondsNum=1; N = 10^5; transient = 7*10^6;
	binarizedData = importdata(filepath);
	[h,J] = pfunc_02_Inferrer_ML(binarizedData);
	E = mfunc_Energy(h, J);
	[LocalMinIndex, BasinGraph, AdjacentList] = mfunc_LocalMin(nodeNumber, E);
        [probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
	[basins, freq, freqTrans, freqDirectTrans, basinSizePercent, simulatedStates] = simulateAndPlotDynamics(h, J, BasinGraph, LocalMinIndex, initCondsNum, transient, N);
	StateDurationMap = computeDurationOfStates(simulatedStates);

%%basin size
	%labels = {'Basin 1', 'Basin 2'};
	labels= {};
	for ii = 1:length(basins);
		labels{end + 1} = sprintf('Basin %d', ii);
	end
	fig = figure; bar(categorical(labels), basinSizePercent, 0.3);
	ylabel('percentage of states belonging to a basin');
	title('basin sizes in terms of percentage');
	%customSaveFigure(flag, fig, group, 'basinSize');

%%frequency of basin stay
	fig = figure; bar(categorical(labels), freq, 0.3);
	title('relative frequency of basins from random walk');
	ylabel('frequency');
	%customSaveFigure(flag, fig, group, 'freqStay');

%%transition frequencies
	transLabels = {};
	transFreqs = [];
	for ii= 1:length(basins);
	    for jj = ii+1:length(basins);
	      transFreqs = [transFreqs freqTrans(ii,jj)];
	      transLabels{end+1} = sprintf('Basin %d to %d', ii,jj);
	    end
	end
	fig = figure; bar(categorical(transLabels), transFreqs, 0.3);
	%transLabels = {'Basin 1 to 2', 'Basin 2 to 1'};
	%fig = figure; bar(categorical(transLabels), [freqTrans(1,2), freqTrans(2,1)], 0.3);
	ylabel('Frequency'); title('Transition Frequencies');
	%customSaveFigure(flag, fig, group, 'transition');

%%basin duration
	mean_basin_dur  = zeros(1, length(basins));
	std_basin_dur = zeros(1, length(basins));
	basinDurations = {};
	for ii= 1:length(basins)
		duration = StateDurationMap(basins(ii));
		basinDurations{end+1} = duration;
		mean_basin_dur(ii) = mean(duration);
		std_basin_dur(ii) = std(duration);
	end
	fig = figure; hold on; bar(categorical(labels), mean_basin_dur, 0.2);
	ylabel('duration');
	%xCnt = (get(fig1(1),'XData') + cell2mat(get(fig1,'XOffset')));
	hold on; errorbar([1:length(basins)]', mean_basin_dur(:), std_basin_dur(:), 'k', 'LineStyle','none');
	title('duration from random walk');
	%customSaveFigure(flag, fig, group, 'duration');

%%save every relevant variable to a .mat file
	prefix = "";
	if flag == 1; prefix = "gsr";
	elseif flag == 0; prefix = "no_gsr";
	elseif flag == 2; prefix = "exactEzaki";
	end
	filename = sprintf('%s_%dmm', strcat(prefix, "_", group, "_MEM_results"), sphereRadius);
	save(filename, 'h', 'J', 'rD', 'r', 'probN', 'freq', 'transLabels', 'transFreqs', 'basinSizePercent', 'basinDurations','mean_basin_dur', 'std_basin_dur');
%% close the figures before continuing
%	close all;
%end
%end

%%summarize the results. Mostly for adding in Google slides
%TBD: figure out if image of a table can be programitically created
%for diaggroup = ["asd_child", "asd_adolsc", "asd_adult", "td_child", "td_adolsc", "td_adult"];
%for flag = [0 1 2];
%        flag = 2;
%	fprintf('group: %s | Flag: %d\n', diaggroup, flag);
%	prefix = ""; 
%        if flag == 1; prefix = "gsr";
%	elseif flag == 0; prefix = "no_gsr";
%	elseif flag == 2; prefix = "exactEzaki";
%	end
%        filename = strcat(prefix, "_", diaggroup, "_MEM_results")
%	datastruct = load(filename);
%	freq = datastruct.freq; basinSizePercent = datastruct.basinSizePercent;
%	transLabels = datastruct.transLabels; transFreqs = datastruct.transFreqs;
%	mean_basin_dur = datastruct.mean_basin_dur; std_basin_dur = datastruct.std_basin_dur;
%
%	fprintf('N(minima) = %d.\n', length(freq))
%	fprintf('Accuracy. rD = %f, r = %f.\n', datastruct.rD, datastruct.r);
%	disp(['Basin sizes - [' num2str(basinSizePercent(:).') ']']);
%	disp(['Basin stay freq - [' num2str(freq(:).') ']']);
%	disp('Transition Frequencies:')
%	for jj = 1:length(transLabels)
%		fprintf('%s: %f\n', transLabels{jj}, transFreqs(jj))
%	end
%	disp('Durations:')
%	for jj = 1:length(freq);
%		fprintf('Mean ± std of Basin %d: %f ± %f\n', jj, mean_basin_dur(jj), std_basin_dur(jj));
%	end
%	fprintf('-------------\n')
%end
%end

function customSaveFigure(flag, fig, group, property)
	prefix = '';
	if flag == 1; prefix = '(gsr)';
	elseif flag == 0; prefix = '(no gsr)';
	elseif flag == 2; prefix = '(exact Ezaki)';
	end
	saveas(fig, [prefix ' ' group '_' property], 'jpg');
end

