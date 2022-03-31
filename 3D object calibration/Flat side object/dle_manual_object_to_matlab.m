%% get 3D coordinates for the object in every trial for a day
n_trials = 5;
n_cameras = 4;
extension = '\CollectedData_Luka.csv';
directory = 'C:\DeepLabCut\Luka\Mouse 8 Day 1 object_1-Luka-2022-03-29\labeled-data\';
file_names = dir(directory);
file_names = {file_names.name};
file_names(1:2) = [];
file_names = reshape(file_names,[n_trials n_cameras]);
file_names = strcat(directory,file_names);
file_names = strcat(file_names,extension);
coordinates_all = {};
for i=1:n_trials
    [coordinates, ~] = triangulate_object_DLC({file_names{i,:}},P);
    coordinates_all{i} = coordinates;
    idx = find(isnan(coordinates_all{i}));
    coordinates_all{i}(idx) =[];
    coordinates_all{i} = reshape(coordinates_all{i},[numel(coordinates_all{i})/3,3])
end %end trial loop

