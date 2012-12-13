    % this script familiarizes the user with some basic properties of the
% normal distribution, see "Risk and Asset Allocation"-Springer (2005), by A. Meucci
% Section 1.3.2

clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
mu=0;
sigma_2=.1;
NumSimulations=10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute pdf and cdf using matlab functions
sigma=sqrt(sigma_2);
x=[mu-3*sigma : sigma/100 : mu+3*sigma]; % set range
pdf = normpdf(x,mu,sigma);
cdf = normcdf(x,mu,sigma);

% generate sample using matlab functions
X = normrnd(mu,sigma,NumSimulations,1);

% compute quantile using matlab functions
u=[.01 : .01 : .99]; % set range
quantile = norminv(u,mu,sigma);

% compute cf using analytical expression
w=[-3/sigma : 1/(sigma*100) : 3/sigma]; % set range
cf=exp(i*mu*w-(sigma^2)/2*(w.^2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
figure
h=plot(x,pdf,'r');
grid on
xlim([-3 3])
title('pdf')

figure
h=plot(x,cdf,'b');
xlim([-3 3])
grid on
title('cdf')

figure
h=plot(u,quantile,'b');
grid on
title('quantile')

figure
h=plot(w,abs(cf),'r');
grid on
xlim([-3 3])
ylim([0 1])
title('|cf|')

break
figure
NumBins=round(10*log(NumSimulations));
hist(X,NumBins)
[n,Ds]=hist(X,NumBins);
D=Ds(2)-Ds(1);
hold on
h=plot(x,pdf*NumSimulations*D,'r');
grid on
title('pdf/histogram')