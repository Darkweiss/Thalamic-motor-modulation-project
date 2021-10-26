function DecomPoseAnalysis( coeffs )
% AIM: analyse the 'coeff' data from DecomPose.  estimate and plot Prob distributions of the variables. 
% Inputs
% coeff - Nframes x Ncoeff.  Ncoeff = 3 (3D location) + 3 (3D rigid angle) + Nshape shape PCs


% xyz location
figure('units','normalized','outerposition',[0 0.05 1 .95])

subplot(2,3,1)
plot(coeffs(:,1),coeffs(:,2),'.')
xlabel('x'), ylabel('y')
subplot(2,3,4)
[n,bc] = hist3(coeffs(:,1:2),[10 10]);
pcolor(bc{1},bc{2},n')
xlabel('x'), ylabel('y')

subplot(2,3,2)
plot(coeffs(:,1),coeffs(:,3),'.')
xlabel('x'), ylabel('z')
subplot(2,3,5)
[n,bc] = hist3(coeffs(:,[1 3]),[10 10]);
pcolor(bc{1},bc{2},n')
xlabel('x'), ylabel('z')

subplot(2,3,3)
plot(coeffs(:,2),coeffs(:,3),'.')
xlabel('y'), ylabel('z')
subplot(2,3,6)
[n,bc] = hist3(coeffs(:,[2 3]),[10 10]);
pcolor(bc{1},bc{2},n')
xlabel('y'), ylabel('z')

% subplot(2,3,3)
% plot3(coeffs(:,1),coeffs(:,2),coeffs(:,3),'.')
% xlabel('x'), ylabel('y'), zlabel('z')

% rotation angles
figure('units','normalized','outerposition',[0 0.05 1 .95])

subplot(2,3,1)
bc = -162:36:162;
[n] = hist(coeffs(:,4),bc);
bar(bc,n)
xlabel('degrees'), title('Yaw angle')

subplot(2,3,2)
[n] = hist(coeffs(:,5),bc);
bar(bc,n)
xlabel('degrees'), title('Roll angle')

subplot(2,3,3)
bc = 9:18:171;
[n] = hist(coeffs(:,6),bc);
bar(bc,n)
xlabel('degrees'), title('Pitch angle')

% shape components
figure('units','normalized','outerposition',[0 0.05 1 .95])
Nshape = size(coeffs,2)-6;
subplot(2,3,1)
plot(coeffs(:,6+1),coeffs(:,6+2),'.')
xlabel('PC1'), ylabel('PC2')

subplot(2,3,2)
[n,bc] = hist3(coeffs(:,[7 8]),[20 20]);
pcolor(bc{1},bc{2},n')
xlabel('PC1'), ylabel('PC2')


for i = 1:Nshape
    subplot(2,3,3+i)
    pc = coeffs(:,6+i);
    bc = linspace(-3*std(pc),3*std(pc),10);
    [n] = hist(coeffs(:,6+i),bc);
    bar(bc,n)
    xlabel('component')
    title(sprintf('PC %d',i))
end

% interaction between components (location and PCs)

figure('units','normalized','outerposition',[0 0.05 1 .95])
labels = {'x','y','z','yaw','roll','pitch','PC1','PC2','PC3'};

i = 2;
for k = 1:Nshape
    clear n bc
    j = 6+k;
    subplot(Nshape,2,(k-1)*2+1)
    plot(coeffs(:,i),coeffs(:,j),'.')
    axis([-3*std(coeffs(:,i)),3*std(coeffs(:,i)),-3*std(coeffs(:,j)),3*std(coeffs(:,j))])
    xlabel(labels{i}), ylabel(labels{j})
    subplot(Nshape,2,(k-1)*2+2)
    bc{1} = linspace(-3*std(coeffs(:,i)),3*std(coeffs(:,i)),10);
    bc{2} = linspace(-3*std(coeffs(:,j)),3*std(coeffs(:,j)),10);
    n = hist3(coeffs(:,[i j]),bc);
    pcolor(bc{1},bc{2},n')
    xlabel(labels{i}), ylabel(labels{j})
    
end




end

