function[IT_matrix, var_entropy] = Mutual_information_analysis(variable, spikes, varbins,spikebins)
%%% mutual information analysis
%%% This function returns the mutual information between a variable and the
%%% spike count
%%% Input:
%%% - variable - vector of variable values in timebins
%%% - spikes - matrix of all neurons as spike numbers x timebins
%%% - varbins and spikebins - number of bins to be used for uniform data binning for
%%% the variable and spiking data
%%% Output:
%%% IT_matrix - matrix of all neurons' mutual information measures in
%%% column 1, significance in column 2 and the entropy of the neuron in column 3
%%% var_entropy - measre of the entropy of the variable

%% get var entropy
DataRaster = variable;
MethodAssign = {1,1,'UniCB',{varbins}};
StatesRaster_var = data2states(DataRaster, MethodAssign);
Method = 'Ent';
VariableIDs = {1,1,1};
var_entropy = instinfo(StatesRaster_var, Method, VariableIDs);
StatesRaster(2,:) = StatesRaster_var;
clear MethodAssign DataRaster VariableIDs Method
%% iterate over neurons and get mutual information
%initiate the matrix to store the information
IT_matrix = NaN(numel(spikes(:,1),4));
for i=1:numel(spikes(:,1))
DataRaster = spikes(i,:);
%determine the optimal number of bins


% State the data using uniform  bins
MethodAssign = {1,1,'UniCB',{spikebins}};
StatesRaster(1,:) = data2states(DataRaster, MethodAssign);
% calculate bias according to PT
[bias] = calculate_bias(StatesRaster);%currenly in our case Rs is equal to the 

% Perform the information calculation for the single trial across all time
% bins
Method1 = 'PairMI';
VariableIDs = {1,1,1;1,2,1}; % Variables 1 and 2
[IT_matrix(i,1),IT_matrix(i,2)] = instinfo(StatesRaster, Method1, VariableIDs,bias, 'MCOpt', 'on');

%entropy calc for neuron
Method = 'Ent';
VariableIDs = {1,1,1};
IT_matrix(i,3) = instinfo(StatesRaster, Method, VariableIDs);

i
end %end neuron iteration
end
