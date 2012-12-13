% this script shows that the estimates of the mean-variance coordinates of a generic allocation, 
% and thus the satisfaction ensuing from that allocation, are extremely uncertain, when the number 
% of observations in the time series is low
% see "Risk and Asset Allocation" - Springer (2005), by A. Meucci

clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% experiment inputs
NumScenarios=200;

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
Market.LengthSeries=10;                     % not hidden

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Correlation = (1-Market.Correlation) * eye(NumAssets) + Market.Correlation * ones(NumAssets,NumAssets);
Market.LinRets_Cov = diag(Market.St_Devations)*Correlation*diag(Market.St_Devations);

% compute generic (sub-optimal) allocation
Generic = ChoiceSubOptimal(Market,InvestorProfile);    
[Generic_CE,Generic_ExpectedValue,Generic_Variance] = Satisfaction(Generic,Market,InvestorProfile);

% compute true dispersion ellipsoid for generic (sub-optimal) allocation
Ellipsoid_Location=[(Market.LengthSeries-1)/Market.LengthSeries*Generic_Variance
    Generic_ExpectedValue];
Ellipsoid_Dispersion=diag([Generic_Variance^2*( 2*(Market.LengthSeries-1)/(Market.LengthSeries^2) )    Generic_Variance/Market.LengthSeries]);
[EigenVectors,EigenValues] = pcacov(Ellipsoid_Dispersion);
Centered_Ellipse=[]; 
Angle = [0 : pi/500 : 2*pi];
for i=1:length(Angle)
    y=[cos(Angle(i))            % normalized variables (parametric representation of the ellipsoid)
        sin(Angle(i))];
    Centered_Ellipse=[Centered_Ellipse EigenVectors*diag(sqrt(EigenValues))*y];  
end
Ellipsoid = Ellipsoid_Location*ones(1,length(Angle)) + Centered_Ellipse;

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
    
    % estimate satisfaction from generic (sub-optimal) allocation
    [EstimatedGeneric_CE,EstimatedGeneric_ExpectedValue,EstimatedGeneric_Variance] = Satisfaction(Generic,EstimatedMarket,InvestorProfile);                  
    Store_EstimatedGeneric_ExpectedValue=[Store_EstimatedGeneric_ExpectedValue EstimatedGeneric_ExpectedValue];
    Store_EstimatedGeneric_Variance=[Store_EstimatedGeneric_Variance EstimatedGeneric_Variance];
    
end

save DBMainDeceptionInMV
PlotDeceptionInMV
