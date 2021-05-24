%draws phase portraits for |m|,q,Xsg,Xuni in given mean_range and std_range.
%function phasePortraitGenerator(mean_range, std_range, h, J)
%%define range for mean and std.
mean_range = -0.002:0.0005:0.01;
std_range = 0:0.0075:0.15;
xlen = length(mean_range) ; ylen = length(std_range);
Nsims = xlen * ylen; simSpace = [xlen, ylen];
%%specify filepaths for importing h and J matrix
subjectsCollated = 1:12;
parentpath = '/home/vinsea/Documents/Dissertation Docs & Papers/Data Pool/Selected Data/';
foldername = 'ABIDEI_UMich_Samp1_ASD_child'; % ASD children from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp1_TD_child';  % TD children from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp1_ASD_adolsc'; % ASD adolesc  from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp1_TD_adolsc'; % TD  adolesc  from ABIDE I UniMichigan_Sample1
%foldername = 'ABIDEI_UMich_Samp2_ASD_adolsc'; % ASD adolesc from ABIDE I UniMichigan_Sample2
%foldername = 'ABIDEI_UMich_Samp2_TD_adolsc'; % TD  adolesc from ABIDE I UniMichigan_Sample2
label = sprintf('%.0f,', subjectsCollated); label = label(1:end-1); %a label with concatenated subject IDs
filepath = sprintf('%s%s', parentpath, strcat('timeseries_', foldername));
result_file_h = sprintf('%s/h_matrix_All264rois_subj %s.txt', filepath, label)
result_file_J = sprintf('%s/J_matrix_All264rois_subj %s.txt', filepath, label)
%%import h and J;
h = importdata(result_file_h);
J = importdata(result_file_J);
%%for empirical data - h and J as supplied. For each (mean,std) pair from mean_range,std_range, Jij transformed as per eqn (3) in Ezaki et. al. 2020.
N = length(J); %number of ROIs
mean_x = []; std_y = []; %values of x and y coordinates for the grid plot.
%fill all mean_x and std_y vals for subsequent use. caution: column-wise traversal where mu is the row and sigma are the columns. Needed because ind2sub in parfor code below uses column-wise traversal.
for sigma = std_range;
  for mu = mean_range;
	mean_x(end+1) = mu;
	std_y(end+1) = sigma;
	end
end
[X,Y]= meshgrid(mean_x,std_y);
%%generate a parpool for use - needs Parallel Computing Toolbox
maxWorkers = 6; %change accordingly based on system capabilities
pool = gcp('nocreate');
if isempty(pool); %create a parpool with as maximum number of workers as possible
   parpool('local',[2 maxWorkers])
end
%%start simulation for empirical data.
beta = 0.24;
empirical_data = zeros(Nsims, 4);
parfor idx = 1:Nsims; %flatten the simulation for parallel computing toolbox.
	[ii,jj] = ind2sub(simSpace, idx);
	mu = mean_range(ii); sigma = std_range(jj);
	fprintf('empirical data. idx %d. Running mu=%f, sigma=%f.\n',idx,mu,sigma);
	newJ = transformJ(mu, sigma, J);
%	[abs_M, q, Xsg, Xuni] = monteCarloSimulation(h, newJ, beta, 10, N*10^4, 10^4);
	[abs_M, q, Xsg, Xuni] = monteCarloSimulation(h, newJ, beta, 10, N*10^6, 10^7);
	empirical_data(idx, :) = [abs_M, q, Xsg, Xuni];
end
%%start plotting for empirical data;
figure;
%%plot for |m|.
subplot(1,4,1); Z = griddata(mean_x, std_y, empirical_data(:,1), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('|m|'); colorbar;
%%plot for q.
subplot(1,4,2); Z = griddata(mean_x, std_y, empirical_data(:,2), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('q'); colorbar;
%%plot for Xsg.
subplot(1,4,3); Z = griddata(mean_x, std_y, empirical_data(:,3), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('X_{sg}'); colorbar;
%%plot for Xuni.
subplot(1,4,4); Z = griddata(mean_x, std_y, empirical_data(:,4), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('X_{uni}'); colorbar;
sgtitle('empirical data phase portraits');
%write empirical_data to a file to avoid rerun
emp_result_file = sprintf('%s/empirical_mcarlo_sim_result(%s).txt', filepath, label)
writematrix(empirical_data, emp_result_file, 'Delimiter', 'tab');

%%for SK model, each Jij independently drawn from Gaussian(mean, std). (mean,std) pair from mean_range, std_range.
beta = 0.24;
%SK_data = zeros(Nsims, 4);
%%start simulation for SK model.
parfor idx = 1:Nsims; %flatten the simulation for parallel computing toolbox.
	if ismember(idx, alreadyRan); %comment code if unnecessary
		continue;
	end	
	[ii,jj] = ind2sub(simSpace, idx);
	mu = mean_range(ii); sigma = std_range(jj);
	%cnt = cnt + 1;
	fprintf('SK model. idx %d. Running mu=%f, sigma=%f.\n',idx,mu,sigma);
	newJ = createJforSKmodel(mu, sigma, length(J));
	%[abs_M, q, Xsg, Xuni] = monteCarloSimulation(h, newJ, beta, 10, N*10^2, 10^3, false);
	[abs_M, q, Xsg, Xuni] = monteCarloSimulation(h, newJ, beta, 1, N*10^4, 5*10^4, false);
	SK_data(idx, :) = [abs_M, q, Xsg, Xuni]; 
end
%%start plotting for SK Model;
figure;
%%plot for |m|.
subplot(2,2,1); Z = griddata(mean_x, std_y, SK_data(:,1), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('|m|'); colorbar;
%%plot for q.
subplot(2,2,2); Z = griddata(mean_x, std_y, SK_data(:,2), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('q'); colorbar;  
%%plot for Xsg.
subplot(2,2,3); Z = griddata(mean_x, std_y, SK_data(:,3), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('X_{sg}'); colorbar; 
%%plot for Xuni.
subplot(2,2,4); Z = griddata(mean_x, std_y, SK_data(:,4), X, Y);
surf(X,Y, Z); xlabel('mean(J)'); shading interp; view(2);ylabel('std(J)'); title('X_{uni}'); colorbar; 
sgtitle('SK Model phase portraits');
%%write SK_data to a file to avoid rerun
SK_result_file = sprintf('%s/SK_mcarlo_sim_result(%s).txt', filepath, label)
writematrix(SK_data, SK_result_file, 'Delimiter', 'tab');

%%finally, delete the parpool object
delete(gcp('nocreate'));
%end

%creates a symmetric J matrix by selecting Jij values from Gaussian(mu,sigma). N gives the length of the square matrix.
function newJ = createJforSKmodel(mu, sigma, N)
%though randn(N) can be used to create a matrix, taking this approach to fill the upper triangle.
	newJ = zeros(N);
	for ii = 1:N; %make symmetric matrix
		for jj=ii+1:N;
			newJ(ii,jj) = mu + sigma * rand;
			newJ(jj,ii) = newJ(ii,jj);
		end
	end
end

%implements eqn (3) of Ezaki et. al. 2020
function newJ = transformJ(mu, sigma, J)
	[mu_cap, sigma_cap] = calcMeanStdofJ(J);
	newJ = J; N = length(J);
	for ii = 1:N;
		for jj=ii+1:N;
		newJ(ii,jj) = (J(ii,jj)-mu_cap) *(sigma/sigma_cap) + mu;
		newJ(jj,ii) = newJ(ii,jj);
		end
	end
end

function [mu, sigma] = calcMeanStdofJ(J)
	offDiagonal = [];
	N = length(J);
	for ii = 1:N;
		for jj=ii+1:N;
		offDiagonal(end+1) = J(ii,jj);
		end
	end
	mu    = mean(offDiagonal);
	sigma = std(offDiagonal);
end

