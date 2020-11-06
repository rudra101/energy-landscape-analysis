%computes a NxN matrix with each (i,j) position containing Si.Sj val of the supplied spin matrix
function corrMatrix = computeCorrlMatrix(spinConfig)
	[dummy, N] = size(spinConfig);
	if dummy ~= 1;
		errordlg('spin config expected to a be 1XN matrix');
		corrMatrix = NaN; %return NaN for failure
		return;
	end
	corrMatrix = zeros(N); %create a NxN matrix
	for ii = 1:N;
		for jj = ii+1:N;
		corrMatrix(ii,jj) = spinConfig(ii) * spinConfig(jj);
		corrMatrix(jj,ii) = corrMatrix(ii,jj);
		end
	end

end

