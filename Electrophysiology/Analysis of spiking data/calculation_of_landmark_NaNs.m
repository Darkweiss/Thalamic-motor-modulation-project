NaNs = zeros(9,75600);
for i = 1:9
    for n=1:75600
        NaNs(i,n) = isnan(concatinated(i,1,n));
    end
end
sum_NaNs = sum(NaNs,2)'
sum_NaNs = sum_NaNs/75600