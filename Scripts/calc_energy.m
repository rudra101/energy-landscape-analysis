%calculates the energy of a generalized spin config
function energy = calc_energy(spinConfig, h, J)
%preliminary checks
[dummy, N] = size(spinConfig);
if dummy ~= 1;
        errordlg('spin config expected to a be 1XN matrix');
        corrMatrix = NaN; %return NaN for failure
        return;
end
%skipping checks to enforce h as Nx1 matrix or J as NxN matrix.
energy = -sum(h' .* spinConfig); %calc the first-order term
secondOrderSum = 0;
for ii = 1:N;
	for jj = 1:N;
	if jj ~= ii;
	secondOrderSum = secondOrderSum + J(ii,jj)*spinConfig(ii)*spinConfig(jj);
	end
	end
end
energy = energy - 0.5 * secondOrderSum;

end

