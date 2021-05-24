function [maxAccuracy, threshAcc, binarizedData] = maximiseModelFit(thresholdRange, originalData, subject)
        [accuracy,reliability] = deal(zeros(1, length(thresholdRange)));
	h_cell = {}; J_cell = {};
        index = 1;
        for threshold = thresholdRange
        fprintf('Running ML maximization for threshold %f.\n', threshold);
        binarizedData = pfunc_01_Binarizer(originalData,threshold);
        [h,J] = pfunc_02_Inferrer_ML(binarizedData);
        [probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
	h_cell{end+1} = h; J_cell{end+1} = J; %store the vals;
	accuracy(index) = rD;
	reliability(index) = r/rD;
        index = index + 1;
        end
	% find the desired threshold
        [maxAccuracy, accIndx] = max(accuracy);
        threshAcc = thresholdRange(accIndx);
	%calculate the probabilities again
	h = cell2mat(h_cell(accIndx)); J = cell2mat(J_cell(accIndx)); 
	binarizedData = pfunc_01_Binarizer(originalData, threshold);
        [probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
	message = sprintf('. (MaxAcc,Thresh)= (%f,%f). Rel = %f', maxAccuracy, threshAcc, reliability(accIndx));
	%plot the accuracy
	accuracyPlotter(thresholdRange, accuracy, reliability, subject, message)
	%plot the probability
	probPlotter(subject, probN, prob2, prob1);
	%plot the moments
	beta = 0.24;
	momPlotter(subject, beta, h, J, binarizedData)
end

%accuracy vs threshold plotter
function accuracyPlotter(thresholdRange, accuracy, reliability, subject, message)
       h = figure(1);
       plot(thresholdRange, accuracy, 'b'); hold on;
       plot(thresholdRange, reliability, 'r');
       xlabel('threshold for binarization');
       ylabel('value');
       figureTitle = sprintf('Model fit for subject %d', subject);
       title(strcat(figureTitle, message));
       legend('Accuracy of fit', 'Estimation reliability')
       filename = sprintf('Subj %d - accuracy.jpg', subject);
       saveas(h, filename);
       hold off;
end

%plotter of empirical and model probability
function probPlotter(subject, probN, prob2, prob1)
	h = figure(2);
	plot(probN, prob2, 'ro'); hold on;
        plot(probN, prob1, 'bx');
        refline(1,0);
        legend('Pairwise MEM', 'Independent MEM');
        xlabel('Empirical probability');
        ylabel('Model probability');
        title(sprintf('Model vs Empirical probability for subject %d',subject));
        filename = sprintf('Subj %d - probability.jpg', subject);
	saveas(h, filename);
        hold off;
end

%plotter of empirical and model moments
function momPlotter(subject, beta, h, J, binarizedData)
	fprintf('Starting Monte Carlo simulation.\n')
	[abs_M, Q, Xsg, Xuni, avg_spin, avg_corr] = monteCarloSimulation(h, J, beta, 10, 8*10^6, 10^7, true);
	[avg_spin_empirical, avg_corr_empirical] = empiricalDataEstimation(binarizedData);
	h = figure(3);
	plot(avg_spin_empirical, avg_spin, 'ko'); hold on;
	plot(avg_corr_empirical, avg_corr,'rx');
	refline(1,0);
	legend('<S_{i}>','<S_{ij}>');
	title(sprintf('moments of model vs empirical data - subj %d', subject));
	xlabel('empirical data'); ylabel('pairwise MEM');
	filename = sprintf('Subj %d - moments.jpg', subject);
	saveas(h, filename);
	hold off;
end

