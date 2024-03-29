% this script evaluates the ML estimator of location and scatter under the
% lognormal assumption LogN(Mu,Sigma^2), by computing replicability, loss, error, bias and inefficiency
% over a stress-test set of Mu's 
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clear; close all; clc; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=20;  % number of observations in time series

Min_Mu=0; Max_Mu=.5; Steps=7; % stress-test the first parameter in a log-normal market
Sigma=.1;

NumSimulations=2000;   %test replicability numerically 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stress test replicability
Step=(Max_Mu-Min_Mu)/(Steps-1);
Mus=[Min_Mu : Step : Max_Mu];

Stress_Loss_Mu=[]; Stress_Inef2_Mu=[]; Stress_Bias2_Mu=[]; Stress_Error2_Mu=[];
Stress_Loss_Sigma=[]; Stress_Inef2_Sigma=[]; Stress_Bias2_Sigma=[]; Stress_Error2_Sigma=[];
for i=1:Steps % each cycle represents a different stress-test scenario
    CyclesToGo=Steps-i+1

    Mu=Mus(i);
    
    Mu_hats=[]; Sigma_hats=[];
    l=ones(NumSimulations,1);
    for n=1:NumSimulations  % each cycle represents a simulation under a given stress-test scenario
        X= lognrnd(Mu,Sigma,T,1);
        
        dummy = mle(X,'distribution', 'lognormal');
        Mu_hat=dummy(1);
        Sigma_hat=dummy(2);
        
        Mu_hats=[Mu_hats
            Mu_hat];
        Sigma_hats=[Sigma_hats
            Sigma_hat];
    end

    % loss for Mu 
    Loss_Mu = (Mu_hats-l*Mu).^2;
    % square inefficiency for Mu
    Inef2_Mu = std(Mu_hats,1)^2; 
    % square bias for Mu
    Bias2_Mu = (mean(Mu_hats)-Mu)^2; 
    % square error for Mu
    Error2_Mu=mean(Loss_Mu); 

    % loss for Sigma 
    Loss_Sigma = (Sigma_hats-l*Sigma).^2;
    % square inefficiency for Sigma
    Inef2_Sigma = std(Sigma_hats,1)^2; 
    % square bias for Sigma
    Bias2_Sigma = (mean(Sigma_hats)-Sigma)^2; 
    % square error for Sigma
    Error2_Sigma=mean(Loss_Sigma); 
    
    
    % store stress test results
    Stress_Loss_Mu=[Stress_Loss_Mu Loss_Mu];
    Stress_Inef2_Mu=[Stress_Inef2_Mu Inef2_Mu];
    Stress_Bias2_Mu=[Stress_Bias2_Mu Bias2_Mu];
    Stress_Error2_Mu=[Stress_Error2_Mu Error2_Mu];
    Stress_Loss_Sigma=[Stress_Loss_Sigma Loss_Sigma];
    Stress_Inef2_Sigma=[Stress_Inef2_Sigma Inef2_Sigma];
    Stress_Bias2_Sigma=[Stress_Bias2_Sigma Bias2_Sigma];
    Stress_Error2_Sigma=[Stress_Error2_Sigma Error2_Sigma];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
h=PlotEstimatorStressTest(Stress_Loss_Mu,Stress_Inef2_Mu,Stress_Bias2_Mu,...
    Stress_Error2_Mu,Mus,'Mu','Mu');
h=PlotEstimatorStressTest(Stress_Loss_Sigma,Stress_Inef2_Sigma,Stress_Bias2_Sigma,...
    Stress_Error2_Sigma,Mus,'Mu','Sigma');