function [Nu,Mu,Sigma]=FitT(x)

Tolerance=.00000000001*length(x);
Nus=[1 : .5 : 25];

LL=[];
for s=1:length(Nus)
    Nu=Nus(s);
    [Mu,Sigma] = EMforT(x,Nu,Tolerance);
    LL=[LL LogLik(x,Nu,Mu,Sigma)];
end
%h=plot(Nus,LL);
[a,Index]=max(LL);
Nu=Nus(Index);
[Mu,Sigma] = EMforT(x,Nu,Tolerance);

