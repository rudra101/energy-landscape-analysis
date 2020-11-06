%this code tries to simulate spin states over many time points. It returns the observables

function [abs_M, Q, Xsg, Xuni, avg_spin, avg_corr, simulatedStates] = monteCarloSimulation(h, J, beta, initCondsNum, transient, N, printMsg)
% h, J are estimated values of respective model variables.
% beta is for calculating Xsg and Xuni. (see comments below.)
% initCondsNum is the number of initial conditions.
% transient is the number of initial steps to discard from each run.
% N is the the number of samples to consider for average
% printMsg is for toggling printing messages within this function.
% returns trial_spin_avg = 1Xnspins vector containing the avg state of individual spins.
% returns trial_corr_avg = nXn spins vector containing the averaged correlation vals. 
% abs_M is the abs(magnetization) = abs(∑(<Si>/N)).
% Q is the order parameter, ∑sqr(<Si>)/N.
% Xsg is the spin-glass susceptibility = sqr(β).(∑sqr(<SiSj> - mi.mj)/N).
% Xuni is the uniform susceptibility, β.(∑(<SiSj> - mi.mj)/N)
% avg_spin is the avg spin configuration 
% avg_corr is the avg corr of spin
if nargin < 7;
	printMsg = false;
end
nodeNumber = length(h);
spinConfig = zeros(1, nodeNumber);
possibleStates = [-1 1]; %states for spin up and down.
avg_spin = zeros(1, nodeNumber);
avg_corr = zeros(nodeNumber);
abs_M = 0; Q = 0; Xsg = 0 ; Xuni = 0;
simulatedStates = [];
%simulatedStates = zeros(nodeNumber, N*initCondsNum, 'int8'); %contains the simulated runs. size - nodeNumber x (N*initCondsNum). 'int8' to reduce memory. In the same format as binarizedData in main().
indexForSimState = 1; %index which will be used to update `simulatedStates` above.
for simNum = 1:initCondsNum
	magnetizationSingleRun = zeros(1, nodeNumber); %will contain ensemble average of spin states under one trial of Monte-Carlo simulation. For abs_M, Q, Xsg, Xuni
	corrMatrixSingleRun = zeros(nodeNumber); %will contain ensemble average of <Si.Sj> under one trial of Monte-Carlo simulation. For Xsg, Xuni
	
	for ii = 1:nodeNumber; %start by creating a random initial configuration
	toss = (rand >= 0.5) + 1; %toss a coin. >= 0.5 means head(+1). tail(-1) otherwise.
	spinConfig(ii) = possibleStates(toss);
	end
	if printMsg;
	fprintf('At simulation #%d.\n', simNum);
        end
	run = 0;
	while run <= transient + N; %start the simulation
	run = run + 1;
	if run > transient; %could be used for analyses
	magnetizationSingleRun = magnetizationSingleRun + spinConfig;
	corrMatrixSingleRun = corrMatrixSingleRun + computeCorrlMatrix(spinConfig);
	%simulatedStates(:,indexForSimState) = spinConfig'; %store the simulated state
	indexForSimState = indexForSimState + 1;
	end
	%%select a random spin to flip
	spinToFlip = randi([1 nodeNumber]);
	flippedState = spinConfig; flippedState(spinToFlip) = spinConfig(spinToFlip)*-1;
	%calculate the energy diff. Again, the steps below can be made parallel.
	originalEnergy = calc_energy(spinConfig, h, J);
	flippedEnergy = calc_energy(flippedState, h, J);
	probability = min(1, exp(originalEnergy - flippedEnergy));
	if rand <= probability %accept the flipped state
		spinConfig = flippedState;
	end
	end
	%all the below assignments can be made parallel
	%avg_spin = avg_spin + (magnetizationSingleRun ./ N);
	%avg_corr = avg_corr + (corrMatrixSingleRun ./ N);
	abs_M = abs_M + abs(mean(magnetizationSingleRun/N));
	Q = Q + mean((magnetizationSingleRun/N).^2); 
	[Xsg_run, Xuni_run] = calculateSusceptibility(beta, corrMatrixSingleRun/N, magnetizationSingleRun/N); %calculate ensemble average and then compute susceptibility.
	Xsg = Xsg + Xsg_run; Xuni = Xuni + Xuni_run;
end
	%trial_spin_avg = spin_avg / (N * initCondsNum);
	%trial_corr_avg = corr_avg / (N * initCondsNum);
	abs_M = abs_M / initCondsNum; Q = Q / initCondsNum;
	Xsg = Xsg / initCondsNum; Xuni = Xuni / initCondsNum;
	%avg_spin = avg_spin/initCondsNum; avg_corr = avg_corr/initCondsNum;
end

