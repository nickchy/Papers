% this script computes the COP posterior given 
% - a market prior, represented by a joit set of Monte Carlo simulations
% - a set of views, represented by a set of marginal cdf's
% see A. Meucci "Beyond Black-Litterman in Practice", 2006, Risk Magazine, 19, 9, 114-119
% the paper can be dowloaded at www.symmys.com > Research > Finance Publications

clear; close all; clc;

GenerateMCPrior=0; % decide whether to generate a new prior (=1) 
                   % or use a previously generated panel of MC scenarios (=0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter prior: JxN matrix of simulated joint market realizations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if GenerateMCPrior
    EstimateNGeneratePrior
end
load dbPriorMC
[J,N]=size(MPrior); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter views and confidence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize pick matrix
K=2;
P=zeros(K,N); 

% view on the 2-5-10 butterfly
P(1,2)=-.5; P(1,3)=1; P(1,4)=-.5;
a_b(1,:)=.0001*[0 5];
c(1)=.25;

% view on slope
P(2,2)=-1; P(2,5)=1;
a_b(2,:)=.0001*[0 10];
c(2)=.25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute posterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: rotate the market into the views' coordinates
P_bar=[P; null(P)'];
V=MPrior*P_bar';

% Step 2: sort the panel of Monte Carlo views scenarios
[W,C]=sort(V(:,[1:K]));
for k=1:K
    x=C(:,k);
    y=[1:J];
    xi=[1:J];
    yi = interp1(x,y,xi);
    C(:,k)=yi/(J+1);
end

for k=1:K
    % Step 3: compute the marginal posterior cdf of each view
    F(:,k)=[1:J]'/(J+1);
    F_hat(:,k)=unifcdf(W(:,k),a_b(k,1),a_b(k,2));
    F_tilda(:,k)=(1-c(k))*F(:,k)+c(k)*F_hat(:,k);
    
    % Step 4: compute joint posterior realizations of the views
    dummy = interp1(F_tilda(:,k),W(:,k),C(:,k),'linear','extrap');
    V_tilda(:,k) = dummy;
end

% Step 5: compute joint posterior realizations of the market distribution
V_tilda=[V_tilda V(:,[K+1:end])];
MPost=V_tilda*inv(P_bar');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% map posterior into returns of securities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load dbPricingFeatures
J=size(MPrior,1); % number of Monte Carlo simulations
N=size(MPrior,2); % number of market factors
L=length(WeeklyCarries);  % number of securities

% mapping the prior
LinearPr = -MPrior*KRDs';
ConvexityFactorPr = (mean(MPrior,2)).^2;
QuadraticPr = ConvexityFactorPr*OACs';
RetsPr = ones(J,1)*WeeklyCarries' + LinearPr + QuadraticPr;

% mapping the posterior
LinearPost = -MPost*KRDs';
ConvexityFactorPost = (mean(MPost,2)).^2;
QuadraticPost = ConvexityFactorPost*OACs';
RetsPost = ones(J,1)*WeeklyCarries' + LinearPost + QuadraticPost;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optimization
% this step depends on the optimization approach of your choice
% Examples are mean-variance and mean-expected shorfall.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

