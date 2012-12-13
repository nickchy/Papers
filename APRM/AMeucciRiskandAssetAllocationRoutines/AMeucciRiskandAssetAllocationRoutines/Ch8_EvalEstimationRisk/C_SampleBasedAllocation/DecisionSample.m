function Allocation = DecisionSample(Market,InvestorProfile)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimate market parameters
Exp_LinRets_Hat=mean(Market.LinRetsSeries)';
Cov_LinRets_Hat=cov(Market.LinRetsSeries);

% compute allocation
Ones=1+0*Exp_LinRets_Hat;
S=inv(Cov_LinRets_Hat);

Allocation = diag(1./Market.CurrentPrices)*S*...
    (InvestorProfile.RiskPropensity*Exp_LinRets_Hat + ...
    (InvestorProfile.Budget - InvestorProfile.RiskPropensity*(Ones'*S*Exp_LinRets_Hat)/(Ones'*S*Exp_LinRets_Hat*Ones))*Ones );







