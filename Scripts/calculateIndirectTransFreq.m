%calculates indirect transitions between states of interest via another state. Say, there are 4 states (1 to 4.) We are interested in indirect trans between 2 and 3. So, the transitions of interest are 2->1->3 and 2->4->3.
%another version is where the minor states repeat at a stretch. Considering same example above, we have 2 -> 1,1,1...-> 3.

function indirectTransFreq = calculateIndirectTransFreq(simulatedStates, statesOfInterest)
	cnt = 0;
	lenWalk = length(simulatedStates);
	ii = 1; jj= 2; kk = 3; %ii, kk track major states. jj is for minor states.
	while kk <= lenWalk;
		state_i = simulatedStates(ii);
		state_j = simulatedStates(jj); state_k = simulatedStates(kk);
		if ismember(state_i, statesOfInterest) && ~ismember(state_j, statesOfInterest) && ismember(state_k, statesOfInterest);
			cnt = cnt + 1;
			ii = kk; jj = ii+1; kk = jj+1; %change the seek to find another transition
			continue;
		end
		ii = ii+1; jj = ii+1; kk = jj+1;
	end
	indirectTransFreq = cnt / lenWalk;
end

