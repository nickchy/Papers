function [sigma,shrinkage]=shrinkDiag(x,shrink)

% function sigma=covdiag(x)
% x (t*n): t iid observations on n random variables
% sigma (n*n): invertible covariance matrix estimator
%
% Shrinks towards diagonal matrix
% if shrink is specified, then this constant is used for shrinkage

% de-mean returns
[t,n]=size(x);
meanx=mean(x);
x=x-meanx(ones(t,1),:);

% compute sample covariance matrix
sample=(1/t).*(x'*x);

% compute prior
prior=diag(diag(sample));

if (nargin < 2 | shrink == -1) % compute shrinkage parameters
  
  % what we call p 
  y=x.^2;
  phiMat=y'*y/t-2*(x'*x).*sample/t+sample.^2;
  phi=sum(sum(phiMat));  
  
  % what we call r
  rho=sum(diag(phiMat));
  
  % what we call c
  gamma=norm(sample-prior,'fro')^2;

  % compute shrinkage constant
  kappa=(phi-rho)/gamma;
  shrinkage=max(0,min(1,kappa/t));
    
else % use specified constant
  shrinkage=shrink;
end

% compute shrinkage estimator
sigma=shrinkage*prior+(1-shrinkage)*sample;

