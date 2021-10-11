%%% this function will take as input the directory with all ephys files
%%% inside and store individual trials in a struct
% function data = sync_multiple_files(path,trial_n)
%     
% end

%get the directory path
trial_n = 1;
path = 'C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\';

for n = 1: trial_n
    file = dir(['Trial ' num2str(trial_n) '*']);
    frame_timings{trial_n} = double(readNPY([path file.name '\Record Node 122\experiment1\recording1\events\Neuropix-PXI-100.0\TTL_1\timestamps.npy'])); %get frame times

    frame_timings{trial_n}      = frame_timings/30000;
    frame_timings(1:2) = []; %remove the starting pulse
    data.trial_length  = numel(frame_timings)/(2*30); %get trial_length in s
    frame_timings(1:2:numel(frame_timings))     = []; %remove every 2nd event as this is the down phase of the TTL pulse
    continuous_timestamps = readNPY([path '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\timestamps.npy']); %read the neuropixel timestamps
    continuous_timestamps = double(continuous_timestamps)/30000;
    frame_timings = frame_timings - continuous_timestamps(1); %subtract the timestamps because events are counted from the start of acquisition not recordings

end
