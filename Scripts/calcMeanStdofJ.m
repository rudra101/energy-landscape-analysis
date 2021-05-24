function [mu, sigma] = calcMeanStdofJ(J)
        offDiagonal = [];
        N = length(J);
        for ii = 1:N;
                for jj=ii+1:N;
                offDiagonal(end+1) = J(ii,jj);
                end
        end
        mu    = mean(offDiagonal);
        sigma = std(offDiagonal);
end

