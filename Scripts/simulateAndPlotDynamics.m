%%plotDynamics plots dynamics of basin, their overall occurence and the transition frequencies
function [basins,freq,freqTrans,freqDirectTrans, basinSizePercent, StateNumber] = simulateAndPlotDynamics(h,J, BasinGraph, LocalMinIndex, initCondsNum, transient, N)
	beta = 0.24;
	nodeNumber = length(h);
	[~, ~, ~, ~, ~, ~, simulatedStates] = monteCarloSimulation(h, J, beta, initCondsNum, transient, N, true);
	%from below follows the analagous steps mentioned in main() for calculating dynamics
	StateNumber = mfunc_GetStateNumber(simulatedStates);
	BasinNumber = mfunc_GetBasinNumber(StateNumber, BasinGraph, LocalMinIndex);
	Nmin = length(LocalMinIndex);
	Dynamics{1} = mfunc_GetDynamics(BasinNumber, Nmin);
	freq = zeros(1, Nmin); %i will contain basin 
	freqDirectTrans = zeros(Nmin, Nmin); %(i,j) will contain frequency of trans between basin i and basin j. 
	freqTrans = zeros(Nmin, Nmin); %(i,j) will contain frequency of trans between basin i and basin j. 
%%fill the frequencies
	freqDirectTrans(1:Nmin+1:end) = NaN;
	freqTrans(1:Nmin+1:end) = NaN;
	freq(:) = Dynamics{1}.Freq(:); %set the frequencies
	for ii = 1:Nmin;
	  for jj=1:Nmin;
	      if ii==jj; continue; end
	      freqDirectTrans(ii,jj) = Dynamics{1}.Dtrans(ii,jj);
	      freqTrans(ii,jj) = Dynamics{1}.Trans(ii,jj);      
	  end
	end
%%create a strip for BasinNumber;
	basindat = BasinNumber;
	basins = unique(basindat);
	figure(105); imagesc(basindat);  hold on;
	cmap = colormap(jet(length(basins)));
	pbaspect([1 8 1]); title('Basins of simulated states');
	text(length(basins),1, 't=1'); text(length(basins),N, sprintf('t=%d',N));
	%find colors for basins and use them for legend as patch
	labels = {};
	for ii = 1:length(basins);
		labels{end+1} = sprintf('Basin %d', ii);
		basinpatch(ii) = patch(NaN, NaN, cmap(ii,:));
	end
	legend(basinpatch, labels);
	axis off; % make the axes vanish
	hold off;
%%create bar plots for individual basins frequencies and sizes(in percentage of total states);
	figure(106);
	subplot(1,2,1);
	bar(categorical(labels), freq, 0.3); ylabel('frequency');
	title('occupancy of basins from model simulation');
%% calculate the basin sizes.
	subplot(1,2,2);
	vectorList = mfunc_VectorList(nodeNumber);
	allStates = mfunc_GetStateNumber(vectorList);
	allStatesBasin = mfunc_GetBasinNumber(allStates, BasinGraph, LocalMinIndex);
	[basins,ia,ic] = unique(allStatesBasin);
	basinSizePercent = 100*accumarray(ic,1) / length(allStates);
	bar(categorical(labels), basinSizePercent, 0.3);
	title('basin sizes in terms of percentage');
	ylabel('percentage of states belonging to a basin');
%%create matrix of transition frequency between states - transition and direct Transition
	%subplots of transition and direct transition with from/to labels.
	figure(107);
	subplot(1,2,1);
	htmp = heatmap(freqDirectTrans);
	htmp.XDisplayLabels = categorical(labels);
	htmp.YDisplayLabels = categorical(labels);
	title('direct transition between basins'); xlabel('To'); ylabel('From');
	subplot(1,2,2); 
	htmp = heatmap(freqTrans);
	htmp.XDisplayLabels = categorical(labels);
	htmp.YDisplayLabels = categorical(labels);
	title('all transition between basins');
	xlabel('To'); ylabel('From');
	%% calculate the basin sizes.
	vectorList = mfunc_VectorList(nodeNumber);
	allStates = mfunc_GetStateNumber(vectorList);
	allStatesBasin = mfunc_GetBasinNumber(allStates, BasinGraph, LocalMinIndex);
	[basins,ia,ic] = unique(allStatesBasin);
	percent_of_states = 100*accumarray(ic,1) / length(allStates);
	basin_sizes = [basins, percent_of_states];
end

