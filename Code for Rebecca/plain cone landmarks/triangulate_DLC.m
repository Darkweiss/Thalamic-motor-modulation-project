%%% This function takes as input n DLC files (n=number of cameras) and
%%% returns 3D coordinates in n_body_landmarks x XYZ X n_frames and miss
%%% which is a matrix of Nbp x number of frames to say if landmark could be
%%% triangulated.
%%%data is a cell array where cells are cameras and each cell contains a
%%%matrix of n_frames x n_landmakrs X Y coordinates
%%%P is the camera matrix
%%% files is a cell array of individual camera files
%%%IF THE POINT CANNOT BE TRIANGULATED AS IT IS NOT DETECTED BY ENOUGH
%%%CAMERAS IT IS SET AT 0 0 0

function[coordinates_3D,miss] = triangulate_DLC(files,P)
Nbp = 14; %nr of bodyparts
Ncam = 4; %nr of cameras
THlike = 0.6;
good_camera = true(Nbp,Ncam);
x_multi = cell(1,Nbp);

%%%%%%%%%%%%%%%%%%%load DLC coordinates%%%%%%%%%%%%%%%%%%%%
data={};
for n = 1:Ncam
    %load camera csv file
    temp = csvread([files{n}],3,1);
    %get Nframe (number of frames) and Nbp (number body points)  
    [Nframe,Nbp] = size(temp);
    
    Nbp = Nbp/2; %used for csv files directly for labelling (only x and y coordinates without likelyhood) -  comment out following for loops until data{n}=temp;
    
    %Nbp = Nbp/3; %used for csv files following DLC network training (x,y,likelyhood => for loops necessary)
    
%    input NaN where thereshold is less than specified
    for i_frames=1:numel(temp(:,1))
        for i_bp = 1:Nbp
            if temp(i_frames,i_bp*2-1) ==0
                temp(i_frames,i_bp*2-1) = NaN;
                temp(i_frames,i_bp*2) = NaN;
            end
        end
    end

data{n}=temp;
end %end camera loop

temp_3D_coordinates= zeros(Nbp,3,Nframe); %matrix to store the 3D coordinates temporarily
miss=false(Nbp,Nframe); % matrix to detect landmarks that can't be triangulated



%get 3D coordinates
for u=1:Nframe
    for n=1:Nbp
        for m = 1:Ncam
            x_multi{n}(1,m) = data{m}(u,(n*2)); 
            x_multi{n}(2,m) = data{m}(u,(n*2-1)); 
            if isnan(data{m}(u,n*2-1)) %check for non visible landmarks and record it in a good_camera matrix
                good_camera(n,m) = false;
            end % end if statement
        end % end num of camera loop
    end %end body landmark loop
    
    for n = 1:Nbp
        ind_ok = find(good_camera(n,:));
        if length(ind_ok)>=2         
            X(:,n) = ls_triangulate(x_multi{n}(:,ind_ok),P(ind_ok));
            temp_3D_coordinates(n,:,u)= X((1:3),n);
        else
            temp_3D_coordinates(n,:,u)= NaN;
            miss(n,u)=true;
        end
        
    end
    good_camera = true(Nbp,Ncam);

end %end frame loop

coordinates_3D = temp_3D_coordinates;
end

