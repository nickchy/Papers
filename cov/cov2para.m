function [sigma,shrinkage]=cov2para(x,usediag,useoff,shrink)

% function sigma=cov2para(x)
% x (t*n): t iid observations on n random variables
% sigma (n*n): invertible covariance matrix estimator
%
% Shrinks towards two-parameter matrix:
%    all variances are the same
%    all covariances are the same
% if shrink is specified then this const. is used for shrinkage

% The full compuation of the `contribution' r to the optimal
% shrinkage constant can be quite computer-intensive (or even lead
% to a memory violation when the dimensions are very large).
% The software can therefore be used in various ways:
% - cov2para(x, 0) does not compute r at all (and sets it to zero instead)
% - cov2para(x, 1) only computes the diagonal contribution to r
% - cov3para(x, 1, 1) also computes the off-diagonal contribution
%   in addition 
% - cov2para(x) actually corresponds to cov2para(x, 1)
% Note that the difference between cov2para(x, 1) and cov2para(x, 1, 1)
% appears negligible ususally, so there appears no harm in ignoring
% the contribution from the off-diagonal in computing r

% The notation follows Ledoit and Wolf (2003)
% This version: 06/2009

% de-mean returns
[t,n]=size(x);
meanx=mean(x);
x=x-meanx(ones(t,1),:);

% compute sample covariance matrix
sample=(1/t).*(x'*x);

% compute prior
meanvar=mean(diag(sample));
meancov=sum(sum(sample(~eye(n))))/n/(n-1);
prior=meanvar*eye(n)+meancov*(~eye(n));

if (nargin < 3 | usediag == 0)
  useoff=0;
end


if (nargin < 4 | shrink < 0) % compute shrinkage parameters
  c=norm(sample-prior,'fro')^2;
  y=x.^2;
  p=1/t*sum(sum(y'*y))-sum(sum(sample.^2));
  r = 0;
  if (nargin < 2 | usediag == 1) % use diagonal in computing r
    rdiag=1/n*sum(sum(cov(y)));
    roff=0;
    if (useoff == 1) % use off-diagonal in computing r
      nvar=(n-1)*n/2;
      z=ones(t,nvar);
      col=1;
      for i=1:(n-1)
        for j=(i+1):n
          z(:,col)=x(:,i).*x(:,j);
          col=col+1;
        end  
      end
      roff=(4/((n*(n-1))))*(1/t)*sum(sum(cov(z)));
    end
    r=rdiag+roff;
  end
  % compute shrinkage constant 
  k=(p-r)/c;
  shrinkage=max(0,min(1,k/t))
else % use specified number
  shrinkage = shrink;
end

% compute the estimator
sigma=shrinkage*prior+(1-shrinkage)*sample;

  





