function [final_landmarks] = Prep_3D_coordinates(refined_landmarks,spikes,raw_landmarks)
%% detect bad frames
counter_bad = 1;
bad_frames = [];
for i_frame = 1: numel(raw_landmarks(1,1,:))
    if sum(ismissing(raw_landmarks(:,1,i_frame))) > 5
        bad_frames(counter_bad) = i_frame;
        counter_bad = counter_bad +1;
    end
end %end frame loop
%% add back the bad frames to refined landmakrs as NaNs
%bad frames could not be refined as not enough landmarks are visible; they
%need to be sorted by size!!!
if numel(bad_frames) > 0
    refined_w_bad = refined_landmarks;
    for i = numel(bad_frames)
        refined_w_bad = cat(3,refined_w_bad(:,:,1:(bad_frames(i) - 1)),NaN(8,3));
        refined_w_bad = cat(3,refined_w_bad,refined_landmarks(:,:,bad_frames(i):end));
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

%% split 3D landmarks back into trials (cell array)
frames = 1;
for i_trials = 1:numel(spikes)
    final_landmarks{i_trials} = refined_landmarks(:,:,(frames:(frames + numel(spikes{1}(1,:)) - 1)));
    frames = frames + numel(spikes{1}(1,:));
end %end trial loop
end %end function
