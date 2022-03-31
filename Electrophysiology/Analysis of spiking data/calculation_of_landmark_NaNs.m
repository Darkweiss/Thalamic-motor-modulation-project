NaNs = zeros(11,75600);
for i = 1:11
    for n=1:75600
        NaNs(i,n) = isnan(concatinated(i,1,n));
    end
end
sum_NaNs = sum(NaNs,2)'