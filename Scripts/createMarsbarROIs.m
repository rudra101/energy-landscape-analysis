%This file has been taken from http://jpeelle.net/mri/misc/marsbar_roi.html and customized to own use.
%% Use MarsBaR to make spherical ROIs


%% Set general options

outDir = 'Power264_4mm-radius';
sphereRadius = 4; % mm

filepath = 'ROI_coords.txt';
% coordinates are nvoxels rows by 3 columns for X,Y,Z
%coords = [1 2 3 4 5 6];
coords = dlmread('ROI_coords.txt'); %read using ASCII delim

%% Error checking: directory exists, MarsBaR is in path
if ~isdir(outDir)
    mkdir(outDir);
end

if ~exist('marsbar')
    error('MarsBaR is not installed or not in your matlab path.');
end


%% Make rois
fprintf('\n');

for i=1:size(coords,1)
    thisCoord = coords(i,:);

    fprintf('Working on ROI %d/%d...', i, size(coords,1));

    roiLabel = sprintf('%i_%i_%i', thisCoord(1), thisCoord(2), thisCoord(3));

   sphereROI = maroi_sphere(struct('centre', thisCoord, 'radius', sphereRadius));

   outName = fullfile(outDir, sprintf('%dmmsphere_%s_roi', sphereRadius, roiLabel));

   % save MarsBaR ROI (.mat) file
   saveroi(sphereROI, [outName '.mat']);

   % save the Nifti (.nii) file
   save_as_image(sphereROI, [outName '.nii']);

   fprintf('done.\n');

end


fprintf('\nAll done. %d ROIs written to %s.',
