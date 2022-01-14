function[bias] = calculate_bias(StatesRaster)
%Rs = number of responses with non-zero probability for each stumulus
Rs = zeros(1, numel(unique(StatesRaster(2,:))));
R = numel(unique(StatesRaster(1,:)));
for i= 1:numel(unique(StatesRaster(2,:)))
    idx = find(StatesRaster(2,:)==i);
    trial_n = numel(idx);
    probability = histcounts(StatesRaster(1,idx))/numel(StatesRaster(1,idx));
    zero_prob = numel(unique(StatesRaster(1,:))) - numel(probability);
    probability = [probability zeros(1,zero_prob)];
    Rs(i)= bayescount_bias_correction(trial_n,probability);
end %end variable bin loop
%calculate bias
bias = 1/((2 * numel(StatesRaster(2,:))) * log(2)) * (sum(Rs-1)-(R-1));
end %end function