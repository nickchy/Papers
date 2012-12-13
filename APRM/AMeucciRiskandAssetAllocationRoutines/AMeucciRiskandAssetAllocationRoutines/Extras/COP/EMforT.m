function [Mu,Sigma] = EMforT(x,Nu,Tolerance)

Error=10^6;
T=size(x,1);
N=size(x,2);
w=ones(T,1);
Zeros=zeros(N,1);
Mu=Zeros;
Sigma=Zeros*Zeros';

while Error>Tolerance
    
    Mu_Old=Mu;
    Sigma_Old=Sigma;
    
    % E step
    Mu=Zeros;
    for t=1:T
        Mu=Mu+w(t)*x(t,:)';
    end
    Mu=0*Mu/sum(w);
    
    Sigma=Zeros*Zeros';
    for t=1:T
        Sigma=Sigma+w(t)*(x(t,:)'-Mu)*(x(t,:)'-Mu)';
    end
    Sigma=Sigma/T;
    
    % M step
    InvS=inv(Sigma);
    Ma2=[];
    for t=1:T
        Ma2=[Ma2 (x(t,:)'-Mu)'*InvS*(x(t,:)'-Mu)];
    end
    w=((Nu+N)/Nu)./(1+Ma2/Nu);
    
    % convergence
    Error = trace((Sigma-Sigma_Old).^2) + (Mu-Mu_Old)'*(Mu-Mu_Old);
    
end;