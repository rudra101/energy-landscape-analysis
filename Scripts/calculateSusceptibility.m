%this code gets the Xsg, Xuni values as per Ezaki 2020.
%avg_corr_matrix contains <Si.Sj> across an already defined ensemble.
%avg_spin_state contains <Si> across an already defined ensemble.

function [Xsg, Xuni] = calculateSusceptibility(beta, avg_corr_matrix, avg_spin_state)
 N = length(avg_spin_state);
 C = 0; %for summed Cij vals. Xuni
 Csqr = 0; %for summed sqr(Cij) vals. Xsg
 for ii = 1:N;
	 for jj = ii:N;
	 val = avg_corr_matrix(ii,jj) - (avg_spin_state(ii)*avg_spin_state(jj));
	 C = C + val; Csqr = Csqr + val^2;
	 end
 end
 Xsg  = Csqr * (beta^2) / N;
 Xuni = C * beta / N;
end

