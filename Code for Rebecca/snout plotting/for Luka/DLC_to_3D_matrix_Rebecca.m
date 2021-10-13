%%This code reads several DLC labeled frame .csv files and combines them
%%into a cell array of where each cell is a camera view matrix of frames on
%%rows and X and Y colums as the coordinates of the landmark. Then 3D
%%coordinates are calculated

%WARNING: THE CODE SETS 3D coordinates as 0 0 0 if the landmark is not
%visible from enough cameras
%% Define some parameters
Ncam = 4; %number of cameras
Nbp = 6; %number of body parts
n_mice= 4; %number of mice
n_weeks = 1;%number of weeks tested
n_days = 3; %number of days
n_objects = 1; %number of objects used
max_trials = 5;
directory = 'C:\Users\v41671rs\Thalamic-motor-modulation-project-main\SSM\all csv files cones 13-15.09\'; % directory where folders of labeled data are located
%model_name = 'DLC_resnet_50_CDOIS studyJun9shuffle1_1030000.csv';
clear data_rbc
%% Loop over the files and put them in a cell array matrix
%The cell array contains output from triangulate_DLC in individual cells
counter =1;
fn = {}; %file names
for mouse_i = 1:n_mice
    %for week_i = 1:n_weeks
        for day_i = 1:n_days
            for objects_i = 1:n_objects
                for trial_i = 0:max_trials
                    for camera_i=1:Ncam
                        filename= ['mouse ' num2str(mouse_i) ' day ' num2str(day_i) ' camera ' num2str(camera_i) ' nor ' num2str(objects_i) '.csv'];
                        if isfile([directory filename])
                            fn{camera_i} =filename;
                        else
                            warning(['Could not find the file ' filename]);
                        end
                    end%end camera iteration
                    if numel(fn)==Ncam && sum(cellfun(@isempty,fn))==0
                        [data_rbc{counter},~] = triangulate_DLC(fn);
                        
                        triangulated_file_names{counter} = fn;
                        fn = {};
                        counter = counter+1;
                        counter 
                    end
                end %end trial iteration
            end %end object iteration
        end %end day iteration
   % end %end week iteration
end %end mouse interation