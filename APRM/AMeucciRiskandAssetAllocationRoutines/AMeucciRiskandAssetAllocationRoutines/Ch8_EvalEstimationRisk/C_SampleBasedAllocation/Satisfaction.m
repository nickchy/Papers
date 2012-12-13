function [CE , e , v] = Satisfaction(Allocation,Market,InvestorProfile)

e=Allocation'*diag(Market.CurrentPrices)*(1+Market.LinRets_EV);
v=Allocation'*diag(Market.CurrentPrices)*Market.LinRets_Cov*diag(Market.CurrentPrices)*Allocation ;

CE = e - 1/(2*InvestorProfile.RiskPropensity)*v;