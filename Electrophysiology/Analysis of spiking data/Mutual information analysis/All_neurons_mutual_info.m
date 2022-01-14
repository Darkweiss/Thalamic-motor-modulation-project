%% analyse all neurons for mutual information for all variables
data = NaN(79,10);
for i=1:10
    for n=1:79
        [IT_matrix, var_entropy] = Mutual_information_analysis(binned_coefficient(i,:), binned_spikes(analysis_id(n),:), 10,10);
        data(n,i) = IT_matrix(:,2);
        clear IT_matrix
    end
    i
end