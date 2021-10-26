%%PCA on single trial data
%combine the trials

%make bins larger
idxs = 1:10:numel(synced_spikes{1}(1,:));
counter=1;
for trial = 1:7
    temp = zeros(548,540);
    for neuron = 1:numel(synced_spikes{1}(:,1))
        for idx = 1:numel(idxs)
            temp(neuron,counter) = sum(synced_spikes{trial}(neuron,idxs(idx):(idxs(idx)+1)));
            counter=counter+1;
        end
        counter = 1;
        neuron
    end
    binned{trial} = temp;
end

PCA = [];
for trial = 1:7
    PCA = cat(2,PCA,binned{trial});
end
   
PCA = PCA';
%PCA = zscore(PCA,[],1);

[eigenvectors,reduced_dimensions,eigenvalues,tsquared,explained]=pca(PCA);
explained(1:10)

%% plotting
figure
xlim([-30 30])
ylim([-30 30])
zlim([-30 30])
hold on
for i_frame = 1:5400    
    scatter3(reduced_dimensions(i_frame,1),reduced_dimensions(i_frame,2),reduced_dimensions(i_frame,3),'MarkerFaceColor','r')
    hold on
    pause(0.1)
end

%%
[vec,val] = eig(cov(PCA));
figure
subplot(1,2,1)
plot(diag(val),'.')
subplot(1,2,2)
tmp = diag(val);
plot(cumsum(tmp(end:-1:1)),'.')

%%
trial = 1;
data = binned{trial};
figure
ax(1) = subplot(3,3,[1:6]);
imagesc(data)
ax(2) = subplot(3,3,[7:9]);
plot(sum(data),'.-')
axis tight
linkaxes(ax,'x');

%% 
neuron_id= 24;
trial = 1;

for n=1:1000       
    plot3(centroid.x(1,1,n),centroid.y(1,1,n),centroid.z(1,1,n),'.','MarkerSize',20,'Color','k');
    hold on
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title(num2str(n))
    view([180 90])
    xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
    if synced_spikes{trial}(neuron_id,n) > 0
        for i = 1:numel(synced_spikes{trial}(neuron_id,n))
            h1 = plot(20,20,'.', 'MarkerSize',40,'Color','r');
            %playblocking(player);
            sound(y,Fs*2)
        end
    end
    pause(0.03)
    clf;   
end