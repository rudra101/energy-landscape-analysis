%writes (appends) data to csv file with a column header depending upon taskType  
function writeToCsv(data, taskType, empiricalFlag);
  if nargin < 3; empiricalFlag = true; % set default flag as true
  end
  filename = "";
  columnHeader = "";
  switch taskType;
  case "basinSizeR" %basinSizezR => model basin size for plotting in R.
    filename = 'asd_td_basinSize_forR';
    columnHeader = ["group", "age", "basin", "basinSize"];
  case "freqR" %freqR => frequencies for plotting in R.
    filename = 'asd_td_freqs_forR';
    columnHeader = ["group", "age", "state", "freq"];
  case "transR" %transR => transitions for plotting in R.
    filename = 'asd_td_trans_forR';
    columnHeader = ["group", "age", "transType", "transFreq"];
  case "durationR" %durationR => mean basin durations for plotting in R.
    filename = 'asd_td_duration_forR';
    if empiricalFlag; columnHeader = ["group", "age", "duration"];
    else columnHeader = ["group", "age", "duration", "std"]; 
    end
  otherwise
    error(sprintf('Tasktype %s not recognised', taskType));
  end
  if size(data, 2) ~= length(columnHeader);
    error('Please check if the number of data columns match with that in column header')
  end
  if ~ empiricalFlag;
	  filename = strcat(filename, "_model");
  else 
	  filename = strcat(filename, "_empirical");
  end
  filename = strcat(filename, ".csv");

  if exist(filename) == 0; %write for the first time.
    writematrix(columnHeader, filename, 'Delimiter', 'comma');
  end
  %append the rest of data
  writematrix(data, filename, 'Delimiter', 'comma', 'WriteMode','append');
end
