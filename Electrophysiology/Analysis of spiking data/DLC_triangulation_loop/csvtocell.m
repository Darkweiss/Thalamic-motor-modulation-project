folder = 'C:\Users\ganta\Github\Motor_modulation_pipeline\Test data\csv DLC files' ;
n_cameras = 4;

cd(folder)
data = {dir('*csv').name};
camera_cell = cell(1,numel(data)/n_cameras);
idx = 1:(numel(data)/n_cameras):numel(data);
for i = 1:numel(data)/n_cameras
    camera_cell{i} = data(idx);
    idx = idx + 1; 
end