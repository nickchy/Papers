% this script computes ES and contributions to ES from each exposure
% - semi-analytically (quadrature under t assumption)
% - naively-empirical (VaR is percentile, contributions are numerical derivative
% - refined-empirical (VaR from kernel smoothing, contributions as expectations
% see "Risk and Asset Allocation" - Springer (2005), by A. Meucci

clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of assets
N=40; 

% market parameters (student t distribution)
Mu=0*rand(N,1);
A=rand(N,N)-.5;
Sigma=A*A';
nu=3;

% allocation
a=rand(N,1)-.5;

% ES confidence
c=.95;

NumSimul=100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analytical
ES_standardized=1/(1-c)*quad('tinv',10^(-10),1-c,[],[],nu);
ES_an=Mu'*a+ES_standardized*sqrt(a'*Sigma*a)
DES_an=Mu+ES_standardized*Sigma*a/sqrt(a'*Sigma*a);
ContrES_an=a.*DES_an;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulations

% generate market prices scenarios
l=ones(NumSimul,1);
diag_s=diag(sqrt(diag(Sigma)));
C=inv(diag_s)*Sigma*inv(diag_s);
X=mvtrnd(C,nu,NumSimul/2);
X=[X         % symmetrize simulations
    -X];
P = l*Mu' + X*diag_s;

% compute and sort wealth
W = P*a;
[Sort_W,Index] = sort(W);
Sort_P=P(Index,:);

% compute spectrum for empirical ES estimation
th=ceil((1-c)*NumSimul); % threshold
spc=zeros(NumSimul,1);
spc([1:th])=1/th;

% compute ES
ES_simul=Sort_W'*spc

% compute gradient as expectation
for n=1:N
    DES_simul(n)=spc'*Sort_P(:,n);
end
% compute marginal contributions
ContrES_simul=a.*DES_simul';

Error=mean((ContrES_simul-ContrES_an).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure

subplot(2,1,1)
bar(ContrES_an)
xlim([0 N+1])
y_lim=get(gca,'ylim');
grid on
title(['analytical: error = 0'])

subplot(2,1,2)
bar(ContrES_simul)
xlim([0 N+1])
set(gca,'ylim',y_lim)
grid on
title(['simulations: error = ' num2str(Error)])