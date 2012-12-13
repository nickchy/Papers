function [ExpectedValue,Volatility, Composition] = EfficientFrontier(NumPortf, Covariance, ExpectedValues)
% This function returns the NumPortf x 1 vector expected returns, 
%                       the NumPortf x 1 vector of volatilities and 
%                       the NumPortf x NumAssets matrix of compositions 
% of NumPortf efficient portfolios whose expected returns are equally spaced along the whole range of the efficient frontier

warning off;
NumAssets=size(Covariance,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of minimum-risk portfolio
FirstDegree=zeros(NumAssets,1);
SecondDegree=Covariance;
Aeq=ones(1,NumAssets);
beq=1;
A=-eye(NumAssets);          % no-short constraint
b=zeros(NumAssets,1);       % no-short constraint
x0=1/NumAssets*ones(NumAssets,1);
MinVol_Weights = quadprog(SecondDegree,FirstDegree,A,b,Aeq,beq,[],[],x0);
MinVol_Return=MinVol_Weights'*ExpectedValues;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of maximum-return portfolio
MaxRet_Return=max(ExpectedValues);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% slice efficient frontier in NumPortf equally thick horizontal sectors in the upper branch only
TargetReturns=MinVol_Return + [0:NumPortf]'*(MaxRet_Return-MinVol_Return)/(NumPortf);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the NumPortf compositions and risk-return coordinates of the optimal allocations relative to each slice

Composition=[];
Volatility=[];
ExpectedValue=[];

for i=1:NumPortf

    % determine least risky portfolio for given expected return
    AEq=[ones(1,NumAssets);
        ExpectedValues'];
    bEq=[1
        TargetReturns(i)];
    Weights = quadprog(SecondDegree,FirstDegree,A,b,AEq,bEq,[],[],x0)';
    Composition=[Composition 
                    Weights];
    Volatility=[Volatility
                sqrt(Weights*Covariance*Weights')];
    ExpectedValue=[ExpectedValue
                    TargetReturns(i)];
end
