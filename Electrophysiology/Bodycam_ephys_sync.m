%%this script will read the analysed kilosort files and align them to 2ms
%%bins corresponding to the length of a frame from the body camera. The
%%the data from the body will be stored with the spike timings 
%% define some things
path               = 'C:\Ephys data\Chronic ephys\Chronic_mouse4_383783\Day 6\Trial 1_2021-10-01_14-34-31'; %ephys path
%camera .csv files
csv_3D             = {'camera1_trial_1_2021-10-01-141058-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_550000.csv','camera2_trial_1_2021-10-01-141112-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_550000.csv', 'camera3_trial_1_2021-10-01-141131-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_550000.csv','camera4_trial_1_2021-10-01-141146-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_550000.csv'};

%read frame timings and spike times
frame_timings      = double(readNPY([path '\Record Node 122\experiment1\recording1\events\Neuropix-PXI-100.0\TTL_1\timestamps.npy']));
frame_timings      = frame_timings/30000;
frame_timings(1:2) = []; %remove the starting pulse
data.trial_length  = numel(frame_timings)/(2*30); %get trial_length in s
frame_timings(1:2:numel(frame_timings))     = []; %remove every 2nd event as this is the down phase of the TTL pulse
continuous_timestamps = readNPY([path '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\timestamps.npy']); %read the neuropixel timestamps
continuous_timestamps = double(continuous_timestamps)/30000;
frame_timings = frame_timings - continuous_timestamps(1); %subtract the timestamps because events are counted from the start of acquisition not recordings

kilosort_path = [path '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort'];
addpath(kilosort_path);
spike_timings   = readNPY('spike_times.npy'); %read Kilosort spike timings
spike_times     = double(spike_timings)/30000; %get the spike timings in s
single_spikes   = readNPY('spike_clusters.npy'); %cluster IDs

%% get spike depths with a helper function
%you need Spikes for ephys data analysis for this to work and add it's path
%here
addpath(genpath('C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Code\Spikes - ephys data analysis\spikes-master'))
load rez
winv = readNPY('whitening_mat.npy');
ycoords = rez.ycoords;
spikeTemplates = readNPY('spike_templates.npy');
tempScalingAmps = readNPY('amplitudes.npy');
temps = readNPY('templates.npy');
[spikeAmps, spikeDepths, templateDepths, tempAmps, tempsUnW, templateDuration, waveforms] = templatePositionsAmplitudes(temps, winv, ycoords, spikeTemplates, tempScalingAmps);
%templateDepth contains all spike depths

%% create a matrix of spikes (synced_spikes)for each frame by looping over the template IDs
synced_spikes = zeros(numel(templateDepths),numel(frame_timings));
for template_id = 0:(numel(templateDepths)-1)
    single_spikes_neuron = single_spikes==template_id; %booleans where selected neuron is spiking or not
    idx                  = find(single_spikes_neuron); %get indicies when selected neuron is spiking
    spikes               = spike_times(idx); % spike times of selected neuron
    
    for frame = 1:(numel(frame_timings) - 1)
        n_idx              = find(spikes >= frame_timings(frame) & spikes < frame_timings(frame+1)); %get spike indicies that fire during a trial
        synced_spikes(template_id+1,frame) = numel(n_idx);
    end % end frame loop
    template_id
end % end template_id loop

%% select a neuron
addpath('C:\Github\Thalamic-motor-modulation-project\Electrophysiology');
neuron_id = 272;
[y,Fs]=audioread('beep.wav');
player = audioplayer(y,Fs*2);
playblocking(player);
%% get raw 3D landmarks
addpath('C:\DeepLabCut\Luka\More landmarks chronic test-Luka-2021-09-06\videos\Chronic_mouse4\Day 6');
poses = triangulate_DLC(csv_3D,P);
Np = 8;
line_color = 'k';
cval = 'rbbccgmy';
figure;

%figure('units','normalized','outerposition',[0 0 1 1])
%% plot
for n=1:1000    
    for i = 1:Np
        plot3(poses(i,1,n),poses(i,2,n),poses(i,3,n),'.','MarkerSize',20,'Color',cval(i));
        hold on
    end
    line([poses(1,1,n), poses(2,1,n)],[poses(1,2,n), poses(2,2,n)],[poses(1,3,n), poses(2,3,n)],'Color','k','LineWidth',0.1); %Link snout with left ear
    line([poses(1,1,n), poses(3,1,n)],[poses(1,2,n), poses(3,2,n)],[poses(1,3,n), poses(3,3,n)],'Color','k','LineWidth',0.1); %Link snout with right ear
    line([poses(2,1,n), poses(4,1,n)],[poses(2,2,n), poses(4,2,n)],[poses(2,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link front implant base with left ear
    line([poses(2,1,n), poses(5,1,n)],[poses(2,2,n), poses(5,2,n)],[poses(2,3,n), poses(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with left ear
    line([poses(3,1,n), poses(4,1,n)],[poses(3,2,n), poses(4,2,n)],[poses(3,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
    line([poses(3,1,n), poses(5,1,n)],[poses(3,2,n), poses(5,2,n)],[poses(3,3,n), poses(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
    line([poses(3,1,n), poses(6,1,n)],[poses(3,2,n), poses(6,2,n)],[poses(3,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with right ear
    line([poses(2,1,n), poses(6,1,n)],[poses(2,2,n), poses(6,2,n)],[poses(2,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with left ear
    line([poses(7,1,n), poses(6,1,n)],[poses(7,2,n), poses(6,2,n)],[poses(7,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with midpoint
    line([poses(7,1,n), poses(8,1,n)],[poses(7,2,n), poses(8,2,n)],[poses(7,3,n), poses(8,3,n)],'Color','k','LineWidth',0.1); %Link midpoint with tail base
    
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title(num2str(n))
    view([180 90])
    xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
    if synced_spikes(neuron_id,n) > 0
        for i = 1:numel(synced_spikes(neuron_id,n))
            h1 = plot(20,20,'.', 'MarkerSize',40,'Color','r');
            %playblocking(player);
            sound(y,Fs*2)
        end
    end
    pause(0.03)
    clf;   
end
%% sound
%y = ones(1000000000,1);
%% figure

