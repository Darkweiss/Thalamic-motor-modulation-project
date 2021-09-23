function dat2avi(fndat)
% Convert mikrotron dat movie to uncompressed avi
% RSP 23/9/21

%% user needs to specify:

% path to where the video files are stored:
% dir = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\whisker video sept2021\Trial 3 cut_20210916_112623\';
% fname = 'Trial 3 cut_20210915_151603_20210916_112623.dat';
% dir = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\whisker video sept2021\Trial 4 cut_20210916_112257\';
% fname = 'Trial 4 cut_20210915_152543_20210916_112257.dat';
% dir = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\whisker video sept2021\Trial 5 cut_20210916_112838\';
% fname = 'Trial 5 cut_20210915_153416_20210916_112838.dat';
% name of video file you want to open
% framenum = 100; % frame you want to load (eg framenum=1 is the first in the sequence)

%% open the video file and load metadata
video.fid = fopen(fndat,'r');

video.header = read_datfile_header(video.fid);
video.nframes = video.header.nframes;
video.width.raw = video.header.width;
video.height.raw = video.header.height;

% set file position to start of first frame (after the header)
video.offset = 8192;
fseek(video.fid,video.offset,-1);

% specify first frame
% the following is because the video is recorded in a circular buffer.  eg
% a video sequence of 9 frames may be stored in the order:
% 5,6,7,8,9,1,2,3,4.  in which case the 'startframe' is the 6th in the
% stored sequence and 'stopframe' is the 5th in the stored sequence.
% video.startframe = video.header.startframe+1;
% if video.startframe > 1
%     video.stopframe = video.startframe - 1;
% else
%     video.stopframe = video.nframes;
% end

%% create new video
profile = 'Grayscale AVI';
fnavi = [fndat(1:end-3) 'avi'];
v = VideoWriter(fnavi,profile);
open(v)

%% play and save the video
clear imax
figure
for frameidx = 1:video.nframes
%     framenum = video.startframe + frameidx - 1;
%     if framenum > video.nframes
%         framenum = framenum - video.nframes;
%     end
    framenum = frameidx;
    offset = video.header.imagesize * (framenum-1) + video.offset;
    fseek(video.fid,offset,-1);
    tmp = fread(video.fid,video.header.imagesize-24,'uint8=>uint8');
    tmp = reshape([tmp; zeros(24,1)],video.width.raw,video.height.raw)';
    if ~exist('imax','var')
        % set imax from the first frame
        imax = prctile(tmp(:),99.5);
    end
    imshow(tmp,[0 imax])
    writeVideo(v,tmp);
    title(framenum)
    pause(.1)
end

%% close video
close(v)
clear v

end
%% subfunctions

function [ data ] = read_datfile_header( fid )

% rsp 080713 (exactly as in dat2mat)

data.offset = fread(fid,1,'uint32');
data.header = fread(fid,1,'uint32');

data.header_sig = fread(fid,20,'char=>char');
data.record_start = fread(fid,30,'char=>char');
data.camera_name = fread(fid,100,'char=>char');

data.header_sig;
data.record_start;
data.camera_name;

data.camera_man = fread(fid,100,'char=>char');
data.camera_model = fread(fid,100,'char=>char');
data.camera_firmware = fread(fid,100,'char=>char');
data.camera_serial = fread(fid,100,'char=>char');
data.usercomment = fread(fid,1024,'char=>char');

data.hack = fread(fid,2,'char=>char');

data.camera_count = fread(fid,1,'uint32');
data.xoffset = fread(fid,1,'uint32');
data.yoffset = fread(fid,1,'uint32');
data.width = fread(fid,1,'uint32');
data.height = fread(fid,1,'uint32');
data.imagesize = fread(fid,1,'uint32');
data.framerate = fread(fid,1,'uint32') ;     % fps
data.exposuretime = fread(fid,1,'uint32');   % muS
data.dataformat = fread(fid,1,'uint32');


data.bayer = fread(fid,3,'double');
data.gamma = fread(fid,3,'double');
fseek(fid,1672,-1);
data.nframes = fread(fid,1,'uint64');
data.startframe = fread(fid,1,'uint64');
data.triggerframe = fread(fid,1,'uint64');
data.triggertick = fread(fid,1,'uint64');
data.internal = fread(fid,1,'uint64');
data.internal = fread(fid,1,'uint32');
data.imageblitz = fread(fid,4,'uint32');
data.irig = fread(fid,1,'uint32');
data.tickcountfreq = fread(fid,1,'uint64');


end

