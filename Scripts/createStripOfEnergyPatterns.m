function createStripOfEnergyPatterns(energy)
energy = [energy, energy(:,end)];
energy = [energy; energy(end,:)];
states = length(energy) - 1; %subtracting one because of padding 
figure(104);
surf(energy);
view([0 -90]); %invert to keep brain state top down
colorbar;
title('Energy of all states');
pbaspect([1 8 1]); %set aspect ratio; y-axis bigger for prettyfying
text(2.1, 1, 'Brain state 1');
text(2.1, states, sprintf('Brain state %d', states));
axis off; % remove the axis for just the strip
end


