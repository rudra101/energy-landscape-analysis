%Fig 1E of Krzemiński et. al. 2020, Energy landscape of resting magnetoencephalography reveals fronto-parietal network impairments in epilepsy
%plots probability of states generated by MEM and that present in data on the same scatter plot.
function plotStateProbForMEMandEmpr(h, J, probN)
	probMEM = mfunc_StateProb(h,J);
	nodeNumber = length(h);
	states = (1:(2^nodeNumber))';
	figure(108);
	plot(states, probMEM, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor','red');
    hold on;
    plot(states, probN, '-o','MarkerSize',10,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor','black');
	xlabel(sprintf('2^{%d} states by indices', nodeNumber));
	ylabel('prob(V)');
	legend('MEM model', 'empirical data');
end
