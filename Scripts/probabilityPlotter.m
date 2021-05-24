% plot scatter plots for probability of empirical data vs
% (a) 2nd order MEM model (b) 1st order MEM model
function probabilityPlotter(subject, probN, prob2, prob1, label)
        h = figure(2);
        plot(probN, prob2, 'ro'); hold on;
        plot(probN, prob1, 'bx');
        refline(1,0);
        legend('Pairwise MEM', 'Independent MEM');
        xlabel('Empirical probability');
        ylabel('Model probability');
	if subject ~= 0;
	 figureTitle = sprintf('Model vs Empirical probability for subject %d',subject);
	else
	 figureTitle = sprintf('Model vs Empirical probability for collated subjects - %s', label);
	end
	title(figureTitle);
        if subject ~= 0;
	 filename = sprintf('Subj %d - probability.jpg', subject);
	else
	 filename = sprintf('probability, collated subjects - %s.jpg', label);
	end
        saveas(h, filename);
        hold off;
end

