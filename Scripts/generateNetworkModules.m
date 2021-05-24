%% summarises network ROIs as correlated and anti-correlated in major and minor states

function resultDict = generateNetworkModules(group, age, localMinIndx, majorStIndx)
 roilist = ["DMN", "FPN", "SAN", "ATN", "SMN", "Auditory", "Visual"];
 % left to right labels of binarised statenumber. Refer pg 6 of users_guide.pdf under Ezaki's energy-landscape-analysis folder
 N = length(localMinIndx);
 minorStIndx = setdiff(1:N, majorStIndx); 
 fprintf('--------------------------------\n');
 fprintf('Summarising for %s %s (%d major, %d minor states):\n', group, age, length(majorStIndx), length(minorStIndx));
 fprintf('--------------------------------\n');
 a = getLetterStates(majorStIndx);
 b = getLetterStates(minorStIndx);
 fprintf('Major states: '); disp(a);
 fprintf('Minor states: '); disp(b);
 % summarise modules in major states
 majorStMap = summariseModules(roilist, localMinIndx, majorStIndx, 'major st');
 % summarise modules in minor states
 minorStMap = summariseModules(roilist, localMinIndx, minorStIndx, 'minor st');
 % convert map to dict
 majorStDict = convertToPyDict(majorStMap);
 minorStDict = convertToPyDict(minorStMap);
 resultDict = py.dict(pyargs('major st', majorStDict, 'minor st', minorStDict));
end

% sends a map containing all "i-j" pairs as keys and pydict containing corr and anticor ROIs. i and j are the numerical indices of basins.
% nodenum is the number of nodes 
function netMap = summariseModules(roilist, localMinIndx, stateIndcs, namePrefix)
   netMap = containers.Map; % the map that will contain corr and anticor nets for each pair of basin indices
   nodeNum = length(roilist);
   for ii = 1:length(stateIndcs);
   for jj = ii+1:length(stateIndcs);
 % Refer pg 6 of users_guide.pdf under Ezaki's energy-landscape-analysis folder
 % for logic of lines 24 to 27
      ind1 = localMinIndx(stateIndcs(ii)) - 1;
      ind2 = localMinIndx(stateIndcs(jj)) - 1;
      binInd1 = dec2bin(ind1, nodeNum);
      binInd2 = dec2bin(ind2, nodeNum);
      antiCor = []; cor = [];
      for kk = 1:nodeNum; % traverse binarised pattern to see why are different
      if binInd1(kk) ~= binInd2(kk); antiCor = [antiCor kk];
      else cor = [cor kk];
      end
      end
      % fill the map with cor and anticor ROIs
      mapIndx = sprintf('%d-%d', stateIndcs(ii), stateIndcs(jj));
      netMap(mapIndx) = py.dict(pyargs('cor', cor, 'anticor', antiCor));      
      % fprintf('  For %s %s & %s:\n', namePrefix, char(stateIndcs(ii)+ 64), char(stateIndcs(jj)+ 64));
      % fprintf('    Correlated ROIs: ');
      % if length(cor) > 0; disp(roilist(cor));
      % else fprintf('\n');
      % end
      % fprintf('    Anti-correlated ROIs: ');
      % disp(roilist(antiCor));
      % now, find the ROIs in anti-correlated ROIs showing inverted activity across the states
      % posIndx = find(binInd1(antiCor) == '1'); % find '1' in anti-cor group;
      % negIndx = setdiff(1:length(antiCor), posIndx);
      % fprintf('    In %s %s, the active ROIs in anti-correlated group are: ', namePrefix, char(stateIndcs(ii)+64))
      % disp(roilist(antiCor(posIndx)))
      % fprintf('    In %s %s, the inactive ROIs in anti-correlated group are: ', namePrefix, char(stateIndcs(ii)+64))
      % disp(roilist(antiCor(negIndx)))
   end
   end
end

function result = getLetterStates(indices);
  result = [];
  for ind = indices;
	  result = [result string(char(ind+64))];
  end
end

