% this script shows the true mean-variance coordinates of the sample-based pseudo-optimal allocation 
% in different scenarios. In each scenarios these coordiates are
% mean-variance inefficient
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% experiment inputs
NumScenarios=2000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input investor's parameters
InvestorProfile.Budget=10000;
InvestorProfile.RiskPropensity=1000;
InvestorProfile.Confidence=.93;
InvestorProfile.BudgetAtRisk=.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input market parameters
NumAssets=5;
Min_Std=.06; Max_Std=.36; Step=(Max_Std-Min_Std)/(NumAssets-1);
Market.St_Devations  = [Min_Std : Step : Max_Std]';               % hidden
Market.LinRets_EV= .5*Market.St_Devations;                     % hidden

Market.Correlation = .4;                    % hidden
Market.CurrentPrices=10*ones(NumAssets,1);  % not hidden
Market.LengthSeries=20;                     % not hidden

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Correlation = (1-Market.Correlation) * eye(NumAssets) + Market.Correlation * ones(NumAssets,NumAssets);
Market.LinRets_Cov = diag(Market.St_Devations)*Correlation*diag(Market.St_Devations);

% compute optimal allocation, 
Optimal = ChoiceOptimal(Market,InvestorProfile);
[Optimal_CE,Optimal_ExpectedValue,Optimal_Variance] = Satisfaction(Optimal,Market,InvestorProfile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scenario-dependent analysis
Store_EstimatedGeneric_ExpectedValue=[];Store_EstimatedGeneric_Variance=[];Store_PseudoOptimal_ExpectedValue=[];Store_PseudoOptimal_Variance=[];
for s=1:NumScenarios
   
  % generate scenario
    Simul_LinRetsSeries=mvnrnd(Market.LinRets_EV,Market.LinRets_Cov,Market.LengthSeries);
  
    % estimate invariants (linear returns) parameters by sample estimate
    EstimatedMarket.CurrentPrices=Market.CurrentPrices;
    EstimatedMarket.LinRets_EV=mean(Simul_LinRetsSeries)';
    EstimatedMarket.LinRets_Cov=cov(Simul_LinRetsSeries);
    
    % compute the optimal allocation based on estimated market parameters (which is suboptimal) 
    % and the ensuing true (i.e. not estimated) satisfaction
    PseudoOptimal = ChoiceOptimal(EstimatedMarket,InvestorProfile);
    [PseudoOptimal_CE,PseudoOptimal_ExpectedValue,PseudoOptimal_Variance] = Satisfaction(PseudoOptimal,Market,InvestorProfile);
    Store_PseudoOptimal_ExpectedValue=[Store_PseudoOptimal_ExpectedValue PseudoOptimal_ExpectedValue];
    Store_PseudoOptimal_Variance=[Store_PseudoOptimal_Variance PseudoOptimal_Variance];
end

PlotSampleInMV