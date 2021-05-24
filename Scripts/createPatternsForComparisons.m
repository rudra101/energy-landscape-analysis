% this code tries to create strip of activity patterns as per Fig 6a of Watanabe et. al. 2017.

% takes an input netModsDict which is an output of `generateFCvalsForModules.m`. Please refer to that file for input description.
function createPatternsForComparisons(group, age, netModsDict, fileprefix)
   dictKeys = netModsDict.keys();
   for ii = 1:py.len(dictKeys);
    key = char(dictKeys{ii});
    basins = str2double(split(key, '-'))';
    % create strip of patterns
    [pattern1, pattern2, netNames] = getTwoStripOfPatterns(netModsDict{key});
    filename = [char(group) '_' char(age) '_compActivity_' fileprefix '_' key];
    % call functions which will draw the strip of patterns
    drawActivityPatterns(basins, pattern1, pattern2, netNames, filename); 
   end
end

% the top cells will come from anticor patterns. The bottom
% cells will come from cor patterns. Within anticor, the inactive
% nets will be at top. Within cor group. the inactive patterns will
% be at the bottom of the figure.
function [pattern1, pattern2, netNames] = getTwoStripOfPatterns(activityDict)
    roilist = ["DMN", "FPN", "SAN", "ATN", "SMN", "Auditory", "Visual"]; % left to right labels of binarised statenumber. Refer pg 6 of users_guide.pdf under Ezaki's energy-landscape-analysis folder
    pattern1 = zeros(1, 7);
    pattern2 = zeros(1, 7);
    netNames = []; % a string array containing name of nets from top to bottom 
%% deal with anti-correlated patterns - inactive networks on top
    antiCor = activityDict{'anticor'}; %start with anticor
    activeNets = double(antiCor{'active'}); 
    inactiveNets = double(antiCor{'inactive'});
    cnt = 1;
    for jj = inactiveNets; %set anticor patterns
     pattern1(cnt) = -1; pattern2(cnt) = 1;
     netNames = [netNames roilist(jj)]; %set the names of inactive anticor.
     cnt = cnt + 1;
    end
    for jj = activeNets; %set anticor patterns
     pattern1(cnt) = 1; pattern2(cnt) = -1;
     netNames = [netNames roilist(jj)]; %set the names of active anticor.
     cnt = cnt + 1; 
   end
%% deal with correlated patterns - active networks on top
    cor = activityDict{'cor'}; %start with cor
    activeNets = double(cor{'active'}); 
    inactiveNets = double(cor{'inactive'});
    for jj = activeNets; %set cor patterns
     pattern1(cnt) = 1; pattern2(cnt) = 1;
     netNames = [netNames roilist(jj)]; %set the names of active anticor.
     cnt = cnt + 1;
    end
    for jj = inactiveNets; %set cor patterns
     pattern1(cnt) = -1; pattern2(cnt) = -1;
     netNames = [netNames roilist(jj)]; %set the names of inactive anticor.
     cnt = cnt + 1;
    end
end

