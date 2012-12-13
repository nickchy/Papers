% this script highlights the issue of estimation risk: the "optimal" frontier estimated with
% naive estimators changes wildly across different time series realizations
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clear; clc; close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=10;
MaxVolRets=.4;
MinVolRets=.05;
CorrRets=.3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% knowledge of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CorrRets=(1-CorrRets)*eye(N)+CorrRets*ones(N,N);
StepVolRets=(MaxVolRets-MinVolRets)/(N-1);
VolRets=[MinVolRets : StepVolRets : MaxVolRets]';
CovRets=diag(VolRets)*CorrRets*diag(VolRets);
ExpValRets=2.5*CovRets*ones(N,1)/N;

NumPortf=15;
[E,V,Portfolios]=EfficientFrontier(NumPortf, CovRets, ExpValRets);
Portfolios_True=round(100*Portfolios')
PlotFrontier(Portfolios)
title('true frontier','fontweight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation of the market
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=mvnrnd(ExpValRets,CovRets,52);
ExpValRets_Hat=mean(R)';
CovRets_Hat=cov(R);

[E,V,Portfolios]=EfficientFrontier(NumPortf, CovRets_Hat, ExpValRets_Hat);
Portfolios_Naive=round(100*Portfolios')
PlotFrontier(Portfolios)
title('naive estimation frontier','fontweight','bold')