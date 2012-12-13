function Allocation = DecisionPrior(Market,InvestorProfile)

% prior is the equally weighted allocation 
N=length(Market.CurrentPrices);
Allocation=1/N*InvestorProfile.Budget./Market.CurrentPrices;





