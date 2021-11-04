%% shuffle time
%%% this script shifts the coefficients to the left by X amount of bins
function[shuffled_coeffs] = shuffle_time(binned_coeffs)
    P = randperm(size(binned_coeffs,2));
    shuffled_coeffs = binned_coeffs(:,P);
end