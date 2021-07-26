%writes (appends) data to csv file with a column header depending upon taskType  
% CAUTION: since it appends data, please delete the file before re-running the same code path to avoid confusion.
function writeToCsv(data, taskType, empiricalFlag);
  if nargin < 3; empiricalFlag = true; % set default flag as true
  end
  filename = "";
  columnHeader = "";
  switch taskType;
  case "basinSizeR" %basinSizeR => model basin size for plotting in R.
    filename = 'asd_td_basinSize_forR';
    columnHeader = ["group", "age", "basin", "basinSize"];
  case "basinSizeCombnR" %basinSizeCombnR => model basin size (combined major, minor states) for plotting in R.
    filename = 'asd_td_basinSizeCombn_forR';
    columnHeader = ["group", "age", "basin", "basinSize"];
  case "freqCombnR" %freqR => frequencies for combn freqs in R.
    filename = 'asd_td_combined_freqs_forR';
    columnHeader = ["group", "age", "state", "freq"];
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
  case "ageWriterR"
    filename = 'asd_td_ages_forR';
    columnHeader = ["group", "age", "ageInYears"];
  case "fiqWriterR"
    filename = 'asd_td_fiqs_forR';
    columnHeader = ["group", "age", "FIQ"];
  case {"adosTotalWriter", "adosSocialWriter", "adosRRBWriter", "adosCommWriter"}
    charred = char(taskType);
    filename = sprintf('asd_td_%s_forR', charred(1:end-6));
    charred = upper(charred);
    columnHeader = ["group", "age", sprintf('%s_%s', charred(1:4), charred(5:end-6))]; % adjusting for Writer
  case "netModsWriterR"
    filename = 'asd_td_netModsFC_forR';
    columnHeader = ["group", "age", "FCtype" "stateType" "FCval"];
  case "netModsGapR"
    filename = 'asd_td_netModsFC_Gap_forR';
    columnHeader = ["group", "age", "FCoperation" "stateType" "FCval"];
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

