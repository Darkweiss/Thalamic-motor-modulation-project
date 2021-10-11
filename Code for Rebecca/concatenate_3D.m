function [data,file_names] = concatenate_3D (path)
%this function concatenates the 3D triangualted coordinates of individual
%.mat files and returns the order they were concatenated in together with
%number of frames
Files = dir(path);
Files = Files(~ismember({Files.name},{'.','..'}));
%get file names and concatenate them
data = [];
for n = 1 : length(Files)
    file_names{n} = Files(n).name;
    load ([path file_names{n}],'x');
    [~,~,frames] = size(x);
    file_names{n} = [file_names{n} ' ' num2str(frames) ' frames'];
    data = cat(3,data,x);
end
end