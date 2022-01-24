function [] = display_active_frames(video,oe_path,save_dir)
% display_active_frames displays the frames when the whisker cam starts
% becoming active a frame in the middle of the acquisiton epoch and the
% last frame (if the camera records 500fps)


%% loop over trials and extract spikes/per frame
%body cam frames
frame_timings = double(readNPY([oe_path '\Record Node 104\experiment1\recording1\events\Crossing_Detector-102.0\TTL_1\timestamps.npy'])); %get frame times
frame_timings      = frame_timings/30000;
frame_timings(1:2) = []; %remove the starting pulse
frame_timings(1:2:numel(frame_timings))     = []; %remove every 2nd event as this is the down phase of the TTL pulse

%whisker cam frames
whisker_cam = double(readNPY([oe_path '\Record Node 104\experiment1\recording1\events\Crossing_Detector-103.0\TTL_1\timestamps.npy'])); %get frame times
whisker_cam = whisker_cam/30000;
whisker_cam(1:2) = []; %remove the starting pulse
whisker_cam(1:2:numel(whisker_cam))     = []; %remove every 2nd event as this is the down phase of the TTL pulse

whisker_cam = whisker_cam - frame_timings(1);
frame_timings = frame_timings - frame_timings(1); %subtract the timestamps because events are counted from the start of acquisition not recordings
%assign a body cam frame to each whisker cam activation

%remove whisker cam frames that are not in the body cam frames
idx = find(whisker_cam>frame_timings(end));
whisker_cam(idx) = [];
whisker_bodyc = zeros(1,numel(whisker_cam)); %make a vector to store frame numbers
for i = 1: numel(whisker_cam)
    frame_not_found = 1;
    frame = 1;
    while frame_not_found
        if whisker_cam(i) > frame_timings(frame) && whisker_cam(i) <= frame_timings(frame+1)
            whisker_bodyc(i) = frame;
            frame_not_found = 0;
        end %end if
        frame = frame + 1;
    end %end while
    i
end %end whisker_cam frame loop

cd(save_dir)
%%plotting
obj = VideoReader([video]);
for n = 1:numel(whisker_bodyc)
figure
imshow(read(obj,whisker_bodyc(n)))
title(num2str(whisker_bodyc(n)))
saveas(gcf,[num2str(whisker_bodyc(n)) '.png'])
end
end % end function
