%%% Emrah Simsek %%%
% this code loads Tecan plate reader data for a 96-well plate
% and extracts time course measurements for each of the wells I use in the 
% experiments (notice that I don't use row A, row H, col1 and col12 in the experiments, and hence the code does not extract the data for those)

clear; close all; clc

filename1= '20240528_E22-E23_NuncEdge_SMcaa8_OD600_Longterm'; % assigned name of the data file to be read
[num1, txt1, everything1] = xlsread([filename1 '.xlsx']);

txt1= txt1(:, 2:end)';

txt1= txt1(~cellfun(@isempty,txt1));

trowNo = 32; % manually find the row number for the time information

time = num1(trowNo, :)/3600; % time vector in hours

time = time(:,any(~isnan(time),1)); % remove the time points had been allocated but not used (e.g., NaNs)

num1 = num1(:, 1:length(time));

% extract the time course for each well
% for this create a three dimensional matrix whose first two dimensions
% will refer to the row and column numbers of the wells and the third
% dimension will include the time-course of the corresponding OD600 data

nrow = 8; ncol = 12; ndata = length(time);
M = zeros(nrow, ncol, ndata);

for i=1:ncol
    
    for j=1:nrow
            
        M(j,i, :) = num1((trowNo + 1)+ 12*(j-1) + i, :);
    
    end
    
end

% process and take the moving average
movingMeanProcessData
SaveDataTechRep
