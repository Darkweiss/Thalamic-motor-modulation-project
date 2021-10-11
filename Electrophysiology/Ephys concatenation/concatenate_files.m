%concatinate all the files for kilosort and read the corresponding body cam
%triggers
%% get file names
path = 'C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\'; %this is the path where the folders produced by openephys are
cd(path);
Files = dir(path);
%get file names
for n = 1 : length(Files)
    file_names{n} = Files(n).name;
end

%% go over the files and combine them
kilosort_files = file_names(3:9); %select the files you want for kilosort
[fid_write, errmsg] = fopen('combined.dat', 'w'); %create a a new file to write on


for i = 1:length(kilosort_files)
    fid_read = fopen([path kilosort_files{i} '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\continuous.dat']);
    A = fread(fid_read, '*int16');
    fwrite(fid_write, A, 'int16');
    fclose(fid_read);
    i
end %end file loop
fclose(fid_write)