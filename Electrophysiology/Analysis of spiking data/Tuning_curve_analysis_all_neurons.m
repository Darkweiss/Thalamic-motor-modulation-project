%% get largest differences in tuning curves
Eyx = {};
for i=1:numel(analysis_id)
[Eyx{i}] = tuning_by_time(binned_coefficient(9,:),binned_spikes(analysis_id(i),:),pmtrs,1000,true);
end

%% get the differences
diff =[];
for i=1:numel(analysis_id)
diff(i) = max(Eyx{i})-min(Eyx{i});
end
[sorted, pre_idx] = sort(diff);
sorted(end-10:end)
A=pre_idx(end-10:end)
%% get the ratio between median and max
diff =[];
for i=1:numel(analysis_id)
diff(i) = min(Eyx{i})/max(Eyx{i});
end
[sorted, pre_idx] = sort(diff);
sorted(1:10)
A=pre_idx(1:10)
