function[bias] = MI_QE(StatesRaster)
%%% calculate the true mutual information with quadratic extrapolation
%%% input: StatesRaster (matrix containing both variables already
%%% discretized and binned
%%% output: QE_MI (extrapolated true value)
Method1 = 'PairMI';
VariableIDs = {1,1,1;1,2,1}; % Variables 1 and 2
fractions = [1 2 4];
data = zeros(2,numel(fractions));
for i= 1:numel(fractions)
%original data
    for n=1:fractions(i)
        mean_n = zeros(1,fractions(i));
        idx_rand = randperm(numel(StatesRaster(1,:)));
        data(2,i) = fractions(i);
        sum_idx =1;
        for n_data = 1:fractions(i)
            idx = sum_idx:(sum_idx + (numel(idx_rand)/fractions(i))-1);
            mean_n(n) = instinfo(StatesRaster(:,idx), Method1, VariableIDs,0, 'MCOpt', 'on');
            sum_idx = sum_idx + numel(idx_rand)/fractions(i);
            clear idx
        end        
        data(1,i) = mean(mean_n);
    end%end mean loop
end%end fractions loop
p = polyfit(data(2,:),data(1,:),2);
x1 = linspace(0,fractions(end));
y1 = polyval(p,x1);
figure
hold on
scatter(data(2,:),data(1,:))
plot(x1,y1)

%calculate bias
bias1 = p(1)+ p(2);
bias2 = data(1,1)-polyval(p,0) ;
end