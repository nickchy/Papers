% this script computes and displays the robust Bayesian allocation frontier, which shrinks the sample 
% estimate toward the practitioner's prior by including elliptical uncertainty on both location and scatter
% parameters of a normal market. Three frontiers are computed for three different levels of shrinkage (confidence)
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

close all; clear; clc; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumAssets=6;
Rho=-.2; 
StDevations = .06*[1:NumAssets]';

NumPortf=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mu = .5*StDevations; 
Correlation = (1-Rho) * eye(NumAssets) + Rho * ones(NumAssets,NumAssets);
Sigma = diag(StDevations)*Correlation*diag(StDevations);

Mu_0 = Mu; 
Rho_0=Rho;
StDevations_0=StDevations;
Correlation_0 = (1-Rho_0) * eye(NumAssets) + Rho_0 * ones(NumAssets,NumAssets);
Sigma_0 = diag(StDevations_0)*Correlation_0*diag(StDevations_0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LinRetsSeries=mvnrnd(Mu,Sigma,10); 
Mu_Hat=mean(LinRetsSeries)';
Sigma_Hat=cov(LinRetsSeries);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_0=20; Nu_0=20; T=20;
subplot('Position',[0.3 0.58 0.4 0.35])
ProcessNPlotFrontier(T_0,Nu_0,Mu_0,Sigma_0,T,Mu_Hat,Sigma_Hat,NumPortf)

T_0=10000; Nu_0=10000; T=20;
subplot('Position',[0.05 0.07 0.4 0.35])
ProcessNPlotFrontier(T_0,Nu_0,Mu_0,Sigma_0,T,Mu_Hat,Sigma_Hat,NumPortf)

T_0=20; Nu_0=20; T=10000;
subplot('Position',[0.55 0.07 0.4 0.35])
ProcessNPlotFrontier(T_0,Nu_0,Mu_0,Sigma_0,T,Mu_Hat,Sigma_Hat,NumPortf)