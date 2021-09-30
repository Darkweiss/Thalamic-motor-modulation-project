%%this script will read the analysed kilosort files and align them to 2ms
%%bins corresponding to the length of a frame from the body camera. The
%%the data from the body will be stored with the spike timings 
%% define some things
path          = 'C:\Github\Thalamic-motor-modulation-project\Electrophysiology\Playground_data\Trail 1_2021-09-15_14-56-32';
frame_timings = double(readNPY([path '\Record Node 122\experiment1\recording1\events\Neuropix-PXI-100.0\TTL_1\timestamps.npy']));
frame_timings = frame_timings/30000;
frame_timings(1:2) = []; %remove the starting pulse
data.trial_length = numel(frame_timings)/(2*30); %get trial_length in s
