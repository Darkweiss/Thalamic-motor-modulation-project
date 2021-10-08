%concatinate all the files for kilosort and read the corresponding body cam
%triggers
%% get file names
path = 'C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\';
cd('C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\');
Files = dir('C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\');
for n = 1 : length(Files)
    file_names{n} = Files(n).name;
end

%% select the files you want for kilosort
kilosort_files = file_names(3:9);

for i = 1:length(kilosort_files)
    cd([path kilosort_files{i} '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0']);
    fid = fopen('continuous.dat','r');
    numbers = fread(fid,inf,'*uint8');
    
end %end file loop