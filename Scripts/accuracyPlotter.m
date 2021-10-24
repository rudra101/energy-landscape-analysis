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

