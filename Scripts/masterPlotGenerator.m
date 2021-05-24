%%TBD (make more concrete comments) this is a uber file for generating plots for comparison between ASD and TD along with the future objectives.
nodeNumber = 7; beta=0.24; initCondsNum=1;
transient = 7*10^6; N = 10^5;
%transient = 10; N = 10;
simulatedStates = zeros(nodeNumber, N*initCondsNum, 'int8');
%%start by definining structures for ASD and TD.
ASD.child.J = []; TD.child.J = [];
ASD.adolsc.J = []; TD.adolsc.J = [];
ASD.child.h = []; TD.child.h = [];
ASD.adolsc.h = []; TD.adolsc.h = [];
ASD.child.E = []; TD.child.E = [];
ASD.adolsc.E = []; TD.adolsc.E = [];
ASD.child.basingraph = []; TD.child.basingraph = [];
ASD.adolsc.basingraph = []; TD.adolsc.basingraph = [];
ASD.child.LocalMinIndex = []; TD.child.LocalMinIndex = [];
ASD.adolsc.LocalMinIndex = []; TD.adolsc.LocalMinIndex = [];
%ASD.child.StateDuration = []; TD.child.StateDuration = [];
%ASD.adolsc.StateDuration = []; TD.adolsc.StateDuration = [];
ASD.child.StateDurationMap = containers.Map; TD.child.StateDurationMap = containers.Map;
ASD.adolsc.StateDurationMap = containers.Map; TD.adolsc.StateDurationMap = containers.Map;

%%data for ASD child
ASD.child.J = [0  0.2203  0.1128  0.1840  0.1999  0.1538  0.1886;  0.2203   0  0.0597  0.1473  0.1823  0.1098 -0.0201;  0.1128  0.0597   0  0.1427  0.1713  0.1252  0.0808;  0.1840  0.1473  0.1427   0  0.0894  0.1921  0.0425;  0.1999  0.1823  0.1713  0.0894   0  0.1102  0.1805;  0.1538  0.1098  0.1252  0.1921  0.1102   0  0.1272;  0.1886 -0.0201  0.0808  0.0425  0.1805  0.1272   0];
ASD.child.h = [0.2918; 0.1679; 0.1196; 0.2049; 0.2114; 0.1445; 0.2429];
ASD.child.E = mfunc_Energy(ASD.child.h, ASD.child.J); 
[ASD.child.LocalMinIndex, ASD.child.basingraph, ~] = mfunc_LocalMin(nodeNumber, ASD.child.E);
[ASD.child.basins,ASD.child.freq,ASD.child.freqTrans,ASD.child.freqDirectTrans, ASD.child.basinSizePercent, simulatedStates] = simulateAndPlotDynamics(ASD.child.h,ASD.child.J, ASD.child.basingraph, ASD.child.LocalMinIndex, initCondsNum, transient, N);
%ASD.child.StateDuration = uniqueCount(simulatedStates);
ASD.child.StateDurationMap = computeDurationOfStates(simulatedStates);

%%data for ASD adolsc
ASD.adolsc.J = [0 0.1947 0.1040 0.1707 0.1843 0.1861 0.0834; 0.1947   0 0.0532 0.1214 0.1328 0.1150 -0.0074; 0.1040 0.0532   0 0.1232 0.0985 0.1590 0.0475; 0.1707 0.1214 0.1232   0 0.0555 0.1131 0.0615; 0.1843 0.1328 0.0985 0.0555   0 0.1978 0.1697; 0.1861 0.1150 0.1590 0.1131 0.1978   0 0.0625; 0.0834 -0.0074 0.0475 0.0615 0.1697 0.0625  0];
ASD.adolsc.h = [-0.3146; -0.1649; -0.1856; -0.2634; -0.1974; -0.1349; -0.2211];
ASD.adolsc.E = mfunc_Energy(ASD.adolsc.h, ASD.adolsc.J); 
[ASD.adolsc.LocalMinIndex, ASD.adolsc.basingraph, ~] = mfunc_LocalMin(nodeNumber, ASD.adolsc.E);
[ASD.adolsc.basins,ASD.adolsc.freq,ASD.adolsc.freqTrans,ASD.adolsc.freqDirectTrans, ASD.adolsc.basinSizePercent, simulatedStates] = simulateAndPlotDynamics(ASD.adolsc.h,ASD.adolsc.J, ASD.adolsc.basingraph, ASD.adolsc.LocalMinIndex, initCondsNum, transient, N);
%ASD.adolsc.StateDuration = uniqueCount(simulatedStates);
ASD.adolsc.StateDurationMap = computeDurationOfStates(simulatedStates);

%%data for TD child
TD.child.J = [0 0.1820 0.1270 0.1938 0.2019 0.1199 0.0850; 0.1820   0 0.0205 0.0573 0.1107 0.1552   -0.0111; 0.1270 0.0205   0 0.1244 0.1474 0.0668 0.1572; 0.1938 0.0573 0.1244   0 0.0953 0.1512 0.0684; 0.2019 0.1107 0.1474 0.0953   0 0.1139 0.1067; 0.1199 0.1552 0.0668 0.1512 0.1139   0 0.1203; 0.0850   -0.0111 0.1572 0.0684 0.1067 0.1203   0]; 
TD.child.h = [-0.1196;  -0.0374;  -0.0233;  -0.0650;  -0.0425;  -0.0429;  -0.0423];
TD.child.E = mfunc_Energy(TD.child.h, TD.child.J); 
[TD.child.LocalMinIndex, TD.child.basingraph, ~] = mfunc_LocalMin(nodeNumber, TD.child.E);
[TD.child.basins,TD.child.freq,TD.child.freqTrans,TD.child.freqDirectTrans, TD.child.basinSizePercent, simulatedStates] = simulateAndPlotDynamics(TD.child.h,TD.child.J, TD.child.basingraph, TD.child.LocalMinIndex, initCondsNum, transient, N);
%TD.child.StateDuration = uniqueCount(simulatedStates);
TD.child.StateDurationMap = computeDurationOfStates(simulatedStates);

%%data for TD adolsc
TD.adolsc.J = [0 0.1766 0.1053 0.1737 0.1545 0.1626 0.0517; 0.1766   0 0.0675 0.1001 0.1090 0.1192   -0.0014; 0.1053 0.0675   0 0.1121 0.1216 0.1189 0.0750; 0.1737 0.1001 0.1121   0 0.1650 0.0973 0.1155; 0.1545 0.1090 0.1216 0.1650   0 0.1655 0.1255; 0.1626 0.1192 0.1189 0.0973 0.1655   0 0.0322; 0.0517   -0.0014 0.0750 0.1155 0.1255 0.0322   0];
TD.adolsc.h = [0.0526;  0.0494;  0.0629;  0.0580;  0.0626;  0.0733;  0.0521];
TD.adolsc.E = mfunc_Energy(TD.adolsc.h, TD.adolsc.J); 
[TD.adolsc.LocalMinIndex, TD.adolsc.basingraph, ~] = mfunc_LocalMin(nodeNumber, TD.adolsc.E);
[TD.adolsc.basins,TD.adolsc.freq,TD.adolsc.freqTrans,TD.adolsc.freqDirectTrans, TD.adolsc.basinSizePercent, simulatedStates] = simulateAndPlotDynamics(TD.adolsc.h,TD.adolsc.J, TD.adolsc.basingraph, TD.adolsc.LocalMinIndex, initCondsNum, transient, N);
%TD.adolsc.StateDuration = uniqueCount(simulatedStates);
TD.adolsc.StateDurationMap = computeDurationOfStates(simulatedStates);

%% plots for basin frequency
%ASD vs TD plots for each age group
figure;
subplot(2,2,1); bar(categorical({'Basin 1', 'Basin2'}), [ASD.child.freq(:), TD.child.freq(:)], 0.65, 'grouped');
legend('ASD child', 'TD child','Location','best');
ylabel('probability of occurence'); xlabel('children'); 
subplot(2,2,2); bar(categorical({'Basin 1', 'Basin2'}), [ASD.adolsc.freq(:), TD.adolsc.freq(:)], 0.65, 'grouped');
legend('ASD adolsc', 'TD adolsc','Location','best');
ylabel('probability of occurence'); xlabel('adolescents');
%ASD with age
subplot(2,2,3); bar(categorical({'Basin 1', 'Basin2'}), [ASD.child.freq(:), ASD.adolsc.freq(:)], 0.65, 'grouped');
legend('ASD child', 'ASD adolsc','Location','best'); 
ylabel('probability of occurence'); xlabel('ASD subjects with age'); 
%TD with age
subplot(2,2,4); bar(categorical({'Basin 1', 'Basin2'}), [TD.child.freq(:), TD.adolsc.freq(:)], 0.65, 'grouped');
legend('TD child', 'TD adolsc','Location','best'); 
ylabel('probability of occurence'); xlabel('TD subjects with age');
sgtitle('basin frequencies across groups and ages');

%% plots for basin sizes
%ASD vs TD plots for each age group
figure;
subplot(2,2,1); bar(categorical({'Basin 1', 'Basin2'}), [ASD.child.basinSizePercent(:), TD.child.basinSizePercent(:)], 0.65, 'grouped');
legend('ASD child', 'TD child','Location','best');
ylabel('basin size'); xlabel('children'); 
subplot(2,2,2); bar(categorical({'Basin 1', 'Basin2'}), [ASD.adolsc.basinSizePercent(:), TD.adolsc.basinSizePercent(:)], 0.65, 'grouped');
legend('ASD adolsc', 'TD adolsc','Location','best');
ylabel('basin size'); xlabel('adolescents');
%ASD with age
subplot(2,2,3); bar(categorical({'Basin 1', 'Basin2'}), [ASD.child.basinSizePercent(:), ASD.adolsc.basinSizePercent(:)], 0.65, 'grouped');
legend('ASD child', 'ASD adolsc','Location', 'best'); 
ylabel('basin size'); xlabel('ASD subjects with age'); 
%TD with age
subplot(2,2,4); bar(categorical({'Basin 1', 'Basin2'}), [TD.child.basinSizePercent(:), TD.adolsc.basinSizePercent(:)], 0.65, 'grouped');
legend('TD child', 'TD adolsc','Location','best'); 
ylabel('basin size'); xlabel('TD subjects with age');
sgtitle('basin sizes across groups and ages');

%%plot transition frequencies
%direct transition within children
figure;
ASD_child_Dtrans = [ASD.child.freqDirectTrans(1,2); ASD.child.freqDirectTrans(2,1)];
TD_child_Dtrans = [TD.child.freqDirectTrans(1,2); TD.child.freqDirectTrans(2,1)];
subplot(2,2,1); bar(categorical({'Basin 1 to Basin 2', 'Basin 2 to Basin 1'}), [ASD_child_Dtrans(:) TD_child_Dtrans(:)], 0.65, 'grouped');
legend('ASD child', 'TD child', 'Location','best');
ylabel('transition frequency'); xlabel('children');
%direct transition within adolescents
ASD_adolsc_Dtrans = [ASD.adolsc.freqDirectTrans(1,2); ASD.adolsc.freqDirectTrans(2,1)];
TD_adolsc_Dtrans = [TD.adolsc.freqDirectTrans(1,2); TD.adolsc.freqDirectTrans(2,1)];
subplot(2,2,2); bar(categorical({'Basin 1 to Basin 2', 'Basin 2 to Basin 1'}), [ASD_adolsc_Dtrans(:) TD_adolsc_Dtrans(:)], 0.65, 'grouped');
legend('ASD adolsc', 'TD adolsc', 'Location','best');
ylabel('transition frequency'); xlabel('adolescents');
%ASD - direct transition with age
ASD_child_Dtrans = [ASD.child.freqDirectTrans(1,2); ASD.child.freqDirectTrans(2,1)];
ASD_adolsc_Dtrans = [ASD.adolsc.freqDirectTrans(1,2); ASD.adolsc.freqDirectTrans(2,1)]; 
subplot(2,2,3); bar(categorical({'Basin 1 to Basin 2', 'Basin 2 to Basin 1'}), [ASD_child_Dtrans(:), ASD_adolsc_Dtrans(:)], 0.65, 'grouped');
legend('ASD child', 'ASD adolsc', 'Location','best');
ylabel('transition frequency'); xlabel('ASD group');
%TD - direct transition with age
TD_child_Dtrans = [TD.child.freqDirectTrans(1,2); TD.child.freqDirectTrans(2,1)];
TD_adolsc_Dtrans = [TD.adolsc.freqDirectTrans(1,2); TD.adolsc.freqDirectTrans(2,1)]; 
subplot(2,2,4); bar(categorical({'Basin 1 to Basin 2', 'Basin 2 to Basin 1'}), [TD_child_Dtrans(:), TD_adolsc_Dtrans(:)], 0.65, 'grouped');
legend('TD child', 'TD adolsc', 'Location','best');
ylabel('transition frequency'); xlabel('TD group');
sgtitle('direct transition frequencies across groups and ages');
%TBD: plot all transition frequencies 
%% plot duration of states with errorbars
%fill children duration data
ASD_child_mean_basin1 = mean(ASD.child.StateDurationMap(ASD.child.LocalMinIndex(1)));
ASD_child_mean_basin2 = mean(ASD.child.StateDurationMap(ASD.child.LocalMinIndex(2)));
TD_child_mean_basin1 = mean(TD.child.StateDurationMap(TD.child.LocalMinIndex(1)));
TD_child_mean_basin2 = mean(TD.child.StateDurationMap(TD.child.LocalMinIndex(2)));
ASD_child_std_basin1 = std(ASD.child.StateDurationMap(ASD.child.LocalMinIndex(1)));
ASD_child_std_basin2 = std(ASD.child.StateDurationMap(ASD.child.LocalMinIndex(2)));
TD_child_std_basin1 = std(TD.child.StateDurationMap(TD.child.LocalMinIndex(1)));
TD_child_std_basin2 = std(TD.child.StateDurationMap(TD.child.LocalMinIndex(2)));
%fill adolescents duration data
ASD_adolsc_mean_basin1 = mean(ASD.adolsc.StateDurationMap(ASD.adolsc.LocalMinIndex(1)));
ASD_adolsc_mean_basin2 = mean(ASD.adolsc.StateDurationMap(ASD.adolsc.LocalMinIndex(2)));
TD_adolsc_mean_basin1 = mean(TD.adolsc.StateDurationMap(TD.adolsc.LocalMinIndex(1)));
TD_adolsc_mean_basin2 = mean(TD.adolsc.StateDurationMap(TD.adolsc.LocalMinIndex(2)));
ASD_adolsc_std_basin1 = std(ASD.adolsc.StateDurationMap(ASD.adolsc.LocalMinIndex(1)));
ASD_adolsc_std_basin2 = std(ASD.adolsc.StateDurationMap(ASD.adolsc.LocalMinIndex(2)));
TD_adolsc_std_basin1 = std(TD.adolsc.StateDurationMap(TD.adolsc.LocalMinIndex(1)));
TD_adolsc_std_basin2 = std(TD.adolsc.StateDurationMap(TD.adolsc.LocalMinIndex(2)));
%arrange the data
ASD_child_basin_mean = [ASD_child_mean_basin1; ASD_child_mean_basin2];
ASD_adolsc_basin_mean = [ASD_adolsc_mean_basin1; ASD_adolsc_mean_basin2];
TD_child_basin_mean = [TD_child_mean_basin1; TD_child_mean_basin2];
TD_adolsc_basin_mean = [TD_adolsc_mean_basin1; TD_adolsc_mean_basin2];
ASD_child_basin_std = [ASD_child_std_basin1; ASD_child_std_basin2];
ASD_adolsc_basin_std = [ASD_adolsc_std_basin1; ASD_adolsc_std_basin2];
TD_child_basin_std = [TD_child_std_basin1; TD_child_std_basin2];
TD_adolsc_basin_std = [TD_adolsc_std_basin1; TD_adolsc_std_basin2];
basinLabels = categorical({'Basin 1', 'Basin2'});
%start plotting
figure;
subplot(2,2,1);
%between children
fig1 = bar([ASD_child_basin_mean(:), TD_child_basin_mean(:)], 0.65, 'grouped');
xlabel('children'); ylabel('duration'); 
%start with errorbar
%For xCnt below,get(h(1),'XData') are the x centers of basin. XOffset is undocumented.
xCnt = (get(fig1(1),'XData') + cell2mat(get(fig1,'XOffset')));
hold on;
mean_seq = [ASD_child_basin_mean' ; TD_child_basin_mean']; %make a vector with columns corresponding to ASD and TD data or each basin.
std_seq = [ASD_child_basin_std' ; TD_child_basin_std']; %make a vector with columns corresponding to ASD and TD data or each basin 
errorbar(xCnt(:), mean_seq(:), std_seq(:), 'k', 'LineStyle','none');
legend('ASD child','TD child','Location','best');
set(gca,'xticklabel', basinLabels); hold off;

%between adolescents
subplot(2,2,2);
fig2 = bar([ASD_adolsc_basin_mean(:), TD_adolsc_basin_mean(:)], 0.65, 'grouped');
xlabel('adolescents'); ylabel('duration'); 
%start with errorbar
%For xCnt below,get(h(1),'XData') are the x centers of basin. XOffset is undocumented.
xCnt = (get(fig2(1),'XData') + cell2mat(get(fig2,'XOffset')));
hold on;
mean_seq = [ASD_adolsc_basin_mean' ; TD_adolsc_basin_mean']; %make a vector with columns corresponding to ASD and TD data or each basin.
std_seq = [ASD_adolsc_basin_std' ; TD_adolsc_basin_std']; %make a vector with columns corresponding to ASD and TD data or each basin 
errorbar(xCnt(:), mean_seq(:), std_seq(:), 'k', 'LineStyle','none');
legend('ASD adolsc','TD adolsc','Location','best');
set(gca,'xticklabel', basinLabels); hold off;

%ASD with age
subplot(2,2,3);
fig3 = bar([ASD_child_basin_mean(:), ASD_adolsc_basin_mean(:)], 0.65, 'grouped');
xlabel('ASD group'); ylabel('duration'); 
%start with errorbar
%For xCnt below,get(h(1),'XData') are the x centers of basin. XOffset is undocumented.
xCnt = (get(fig3(1),'XData') + cell2mat(get(fig3,'XOffset')));
hold on;
mean_seq = [ASD_child_basin_mean'; ASD_adolsc_basin_mean']; %make a vector with columns corresponding to ASD and TD data or each basin.
std_seq = [ASD_child_basin_std'; ASD_adolsc_basin_std']; %make a vector with columns corresponding to ASD and TD data or each basin 
errorbar(xCnt(:), mean_seq(:), std_seq(:), 'k', 'LineStyle','none');
legend('ASD child','ASD adolsc','Location','best');
set(gca,'xticklabel', basinLabels); hold off;
%TD with age
subplot(2,2,4);
fig4 = bar([TD_child_basin_mean(:), TD_adolsc_basin_mean(:)], 0.65, 'grouped');
xlabel('TD group'); ylabel('duration'); 
%start with errorbar
%For xCnt below,get(h(1),'XData') are the x centers of basin. XOffset is undocumented.
xCnt = (get(fig4(1),'XData') + cell2mat(get(fig4,'XOffset')));
hold on;
mean_seq = [TD_child_basin_mean'; TD_adolsc_basin_mean']; %make a vector with columns corresponding to TD and TD data or each basin.
std_seq = [TD_child_basin_std'; TD_adolsc_basin_std']; %make a vector with columns corresponding to TD and TD data or each basin 
errorbar(xCnt(:), mean_seq(:), std_seq(:), 'k', 'LineStyle','none');
legend('TD child','TD adolsc','Location','best');
set(gca,'xticklabel', basinLabels); hold off;
sgtitle('basin duration across groups and ages');

%%returns NX2 matrix of form [elem count(elem)] where elem is a unique element in X  
%function res = uniqueCount(X) 
%	a = unique(X);
%	res = [a,histc(X(:),a)];
%end


