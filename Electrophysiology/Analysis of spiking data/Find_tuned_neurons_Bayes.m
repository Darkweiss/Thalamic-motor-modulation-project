%% get largest differences in bayesian tuning curves
%get all the bins of Bayes tuning curves
Eyx = {};
for i=1:numel(analysis_id)
[Eyx{i},xbc] = tuning_curve_bayes(binned_coefficient(6,:),binned_spikes(analysis_id(i),:),pmtrs);
end

%% get the differences
diff =[];
for i=1:numel(analysis_id)
diff(i) = max(Eyx{i})-min(Eyx{i});
end
[sorted, pre_idx] = sort(diff);
sorted(end-10:end)
A=pre_idx(end-10:end)
%% get the ratio between min and max
diff =[];
for i=1:numel(analysis_id)
diff(i) = median(Eyx{i})/max(Eyx{i});
end
[sorted, pre_idx] = sort(diff);
sorted(1:10)
A=pre_idx(1:10)
