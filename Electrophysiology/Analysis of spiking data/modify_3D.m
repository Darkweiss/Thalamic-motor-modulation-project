function[nan_idx, new_3D_coordinates] = modify_3D(concatinated_coordinates,bp_delete)
nan_idx = [];    
if numel(bp_delete)>0
        concatinated_coordinates(bp_delete,:,:)=[];
end
for i=1:numel(concatinated_coordinates(1,1,:))
    if sum(isnan(concatinated_coordinates(:,1,i)))> numel(concatinated_coordinates(:,1,1))-3
        nan_idx = [nan_idx i];
    end
end
concatinated_coordinates(:,:,nan_idx) = [];
new_3D_coordinates = concatinated_coordinates;
end