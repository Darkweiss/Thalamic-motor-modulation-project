function [concatinated, separated] = Triangulation_loop(path,P, n_trials, n_cameras)
cd(path)
concatinated = []; %initialise the concatinated matrix
for trial = 1:n_trials
    for cam = 1:n_cameras
        camera = dir(['*Camera_' num2str(cam) '_trial_' num2str(trial) '*.csv']);
        temp{cam} = camera.name;
    end % end cam loop
    separated{trial} = triangulate_DLC(temp,P);
    concatinated = cat(3,concatinated,separated{trial});
    temp = {};
end %end trial loop
save('Day 1 mouse 5', 'concatinated', 'separated');
end % end funciton
