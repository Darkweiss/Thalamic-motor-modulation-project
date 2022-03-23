folder = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\bodycams\Day5\Robust net iteration 1' ;
n_cameras = 4;

cd(folder)
data = {dir('*csv').name};
camera_cell = cell(1,numel(data)/n_cameras);
idx = 1:(numel(data)/n_cameras):numel(data);
for i = 1:numel(data)/n_cameras
    camera_cell{i} = data(idx);
    idx = idx + 1; 
end