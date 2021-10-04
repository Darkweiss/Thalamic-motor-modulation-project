% this function takes as input a directory and combines triangulates all
% the DLC .csv files and stores them in a 2 x N cell array
function[files] = analyse_directory(path)
    files = dir(path);
    %files = files.name;
end