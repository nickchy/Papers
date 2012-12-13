clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation of prior market distribution and generation of Monte Carlo scenarios from this prior distribution:
% FOR ILLUSTRATION PURPOSE ONLY!
% Each firm is supposed to have an internal reliable estimation procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% upload time series
load dbTreasuryCurve
N=size(ParFitted,2);
YieldChanges=ParFitted(2:end,:)-ParFitted(1:end-1,:);
CurrentYields=ParFitted(end,:);

% fit t coupla to yield changes
[Nu,Mu,Sigma]=FitT(YieldChanges);
[s,C]=cov2corr(Sigma);

% estimate marginals and store result as quantiles
Xs=[];
Fs=[];

% insert preferred habitat/liquidity premium in weekly rate expectations
%            '6m'  '2y'  '5y'   '10y'   '20y'  '30y'
Penalty=.0001*[1    1   -3.5    -4     -3.7     -3.7  ];
for n=1:N
    % truncate empirical distribution where yield changes give rise to
    % negative yields
    DY=YieldChanges(:,n)+Penalty(n);
    NonFeasible=find(CurrentYields(n)+DY<0);
    DY(NonFeasible)=[];
    L=length(DY);

    % kernel smoothing of the truncated empirical cdf
    X_Low=median(DY)-1.2*(median(DY)-min(DY));
    X_High=median(DY)+1.2*(max(DY)-median(DY));

    Step=(X_High-X_Low)/5000;
    X=[X_Low : Step : X_High]';

    eps=.3*std(DY);
    F=0*X;
    for l=1:L
        F=F+normcdf(X,DY(l),eps);
    end
    F=F/(L+1);
    F(end)=1.001;

    Xs=[Xs X];
    Fs=[Fs F];
end


% generate Monte Carlo simulations of the copula
J=50000;
tSample = mvtrnd(C,Nu,J/2);
tSample = [tSample
    -tSample];

U=tcdf(tSample,Nu);

% map Monte Carlo simulations of the copula into Monte Carlo
% simulations for the joint distribution
MPrior=[];
for n=1:N
    yi=.001+.998*U(:,n);
    y=Fs(:,n);
    x=Xs(:,n);
    xi = interp1(y,x,yi);
    MPrior=[MPrior xi];
end
save('dbPriorMC','MPrior','Maturities') 
clear