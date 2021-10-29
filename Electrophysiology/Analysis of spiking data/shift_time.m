%% time shift
%%% this script shifts the coefficients to the left by X amount of bins
function[shifted_coeffs,aligned_spikes] = shift_time(binned_coeffs,binned_spikes,n_bins)
    binned_coeffs(:,1:n_bins) = [];
    binned_spikes(:,(end - n_bins + 1):end) = [];
    shifted_coeffs = binned_coeffs;
    aligned_spikes = binned_spikes;
end