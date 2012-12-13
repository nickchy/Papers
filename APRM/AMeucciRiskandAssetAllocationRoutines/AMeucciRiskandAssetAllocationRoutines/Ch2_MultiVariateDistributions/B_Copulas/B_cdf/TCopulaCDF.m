function F_U = TCopulaCDF(u,nu,Mu,Sigma)

N=length(u);
[s,C] = cov2corr(Sigma);
x=norminv(u,Mu,s');

F_U = mvtcdf(x-Mu./s',C,nu);


