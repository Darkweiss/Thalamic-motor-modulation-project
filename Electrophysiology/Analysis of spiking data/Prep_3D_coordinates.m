function [final_landmarks,final_landmarks_trial] = Prep_3D_coordinates(refined_landmarks,spikes, bad_frames)
%% add back the bad frames to refined landmakrs as NaNs
%bad frames could not be refined as not enough landmarks are visible; they
%need to be sorted by size!!!
if numel(bad_frames) > 0
    refined_w_bad = refined_landmarks;
    for i = 1:numel(bad_frames)
        refined_w_bad = cat(3,refined_w_bad(:,:,1:(bad_frames(i) - 1)),NaN(numel(refined_landmarks(:,1,1)),3));
        refined_w_bad = cat(3,refined_w_bad,refined_landmarks(:,:,bad_frames(i)-i+1:end));
    end
    refined_landmarks = refined_w_bad; %store the full 3D coordinates in refined_landmarks
end %end bad frame loop
%%remove the last frame for each trial as spiking data does not include it
trial_length = numel(spikes{1}(1,:));
for n_trials = 1:numel(spikes)
    idx(n_trials) = trial_length + 1;
    trial_length = trial_length + numel(spikes{1}(1,:)) +1;
end %end trial loop
refined_landmarks(:,:,idx) = [];

final_landmarks = refined_landmarks;
%% split 3D landmarks back into trials (cell array)
frames = 1;
for i_trials = 1:numel(spikes)
    final_landmarks_trial{i_trials} = refined_landmarks(:,:,(frames:(frames + numel(spikes{1}(1,:)) - 1)));
    frames = frames + numel(spikes{1}(1,:));
end %end trial loop
end %end function
