%plotter of empirical and model moments
function momentPlotter(subject, beta, h, J, binarizedData, label)
        fprintf('Starting Monte Carlo simulation.\n')
        [abs_M, Q, Xsg, Xuni, avg_spin, avg_corr] = monteCarloSimulation(h, J, beta, 10, 8*10^6, 10^7, true);
        [avg_spin_empirical, avg_corr_empirical] = empiricalDataEstimation(binarizedData);
        h = figure(3);
        plot(avg_spin_empirical, avg_spin, 'ko'); hold on;
        plot(avg_corr_empirical, avg_corr,'rx');
        refline(1,0);
        legend('<S_{i}>','<S_{ij}>');
        if subject ~= 0;
         figureTitle = sprintf('Model vs Empirical moments for subject %d',subject);
        else
         figureTitle = sprintf('Model vs Empirical moments for collated subjects - %s', label);
        end
        title(figureTitle);
        if subject ~= 0;
         filename = sprintf('Subj %d - moments.jpg', subject);
        else
         filename = sprintf('moments, collated subjects - %s.jpg', label);
        end
	title(figureTitle);
        xlabel('empirical data'); ylabel('pairwise MEM');
        saveas(h, filename);
        hold off;
end

