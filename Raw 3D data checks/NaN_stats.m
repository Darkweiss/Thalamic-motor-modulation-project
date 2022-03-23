%% quality of data
NANs = zeros(9, numel(concatinated(1,1,:)));
for i = 1:numel(concatinated(1,1,:))
    for j = 1:numel(concatinated(:,1,1))
        NANs(j,i) = isnan(concatinated(j,1,i));
    end
end

figure
labels = {'snout','R ear','L ear','L implant base','R implant base','cable','neck base','body midpoint','tail base'};
bar(sum(NANs,2)/numel(concatinated(1,1,:)))
set(gca,'xticklabel',labels)
ylabel('Percentage of NaN frames')

NANframes = zeros(1, numel(concatinated(1,1,:)));
Data2D = reshape(concatinated,3 *numel(concatinated(:,1,1)) ,numel(concatinated(1,1,:)));
for i = 1:numel(concatinated(1,1,:))
    if sum(isnan(Data2D(:,i))) > 0
        NANframes(i) = 1;
    end
end
sum(NANframes)/numel(concatinated(1,1,:))