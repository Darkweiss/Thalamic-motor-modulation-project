function [Eyx,xbc] = tuning_curve_bayes(x,y,pmtrs)
% Estimate tuning of neuron to stimulus variable 'x'.
% 'y' is the spike count of the neuron's response and is assumed mainly to
% be {0,1}
% Code uses a Bayesian trick to cope with nonuniform P(x)
%
%   E[y|x] = Sigma_y y*p(y|x)
%   p(y|x) = p(x|y)*p(y)/p(x)
% For case that y={0,1},
%   Sigma_y y*p(y|x) = 0*p(y=0|x) + 1*p(y=1|x) = p(y=1|x)
% So,
%   E[y|x] = p(y=1|x) = p(x|y=1)*p(y==1)/p(x)
% y=[0,1] is assumed to be an OK approximation below (else can extend code
% to include extra terms in the sum).
%
% some code to test it
% x = rand(1,1000);
% py = (x>0.5).*(x-.5);
% y = rand(size(x))<py;
% pmtrs.prctilelo = 2.5;
% pmtrs.prctilehi = 97.5;
% pmtrs.Nbins = 10;
% [Eyx,xbc] = tuning_curve_bayes(x,y,pmtrs);

N = numel(x);
if numel(y)~=N
    error('x and y must be same size')
end

fprintf('%.1 percent of y samples are >1\n', 100*sum(y>1)/N)
if 100*sum(y>1)/N > 10
    disp('Warning: this function is not really suited to such data')
end
y(y>1) = 1;

xmin = prctile(x,pmtrs.prctilelo);
xmax = prctile(x,pmtrs.prctilehi);

xedges = linspace(xmin,xmax,pmtrs.Nbins);
xbc = 0.5*xedges(1:end-1)+0.5*xedges(2:end);

[Hxvalues, ~] = histcounts(x,xedges);
Px = Hxvalues/sum(Hxvalues); %get the probability distribution for coefficients

Py1 = sum(y)/N; % ie P(y==1) %probability distribution for spikes

[Hxy1values, ~] = histcounts(x(y==1),xedges);
Pxy1 = Hxy1values/sum(Hxy1values);  % ie P(x|y==1) %contitional probability of coefficient when there are spikes

Eyx = Py1*Pxy1./Px; % ie E[y|x]

%figure, plot( xbc,(xbc>0.5).*(xbc-.5),'k-'),legend('Theoretical')
plot(xbc,Eyx,'b.-'), title('Tuning curve')


