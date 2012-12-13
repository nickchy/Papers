function [x,info]=RobSocpMVPortf(m,q,T,Sigma,v_i)
% this function transforms the SOCP mean-variance problem in SeDuMi format
% see the Technical Appendices to Ch 9 of 
% "Risk and Asset Allocation"- Springer (2005), by A. Meucci
% available at www.symmys.com

N=size(Sigma,1);

D_lo=[eye(N) zeros(N,1)];
D_b1=[ones(1,N) 0];
D_b2=[-ones(1,N) 0];
D=[D_lo; D_b1; D_b2]';

f=[zeros(N,1); -1; 1];

b=[-m; 1];

[E,L]=pcacov(T);
c1=zeros(N,1);
A1t=[q*diag(sqrt(L))*E' zeros(N,1)];
b1=[zeros(N,1); 1];
d1=0;

[F,G]=pcacov(Sigma);
c2=zeros(N,1);
A2t=[diag(sqrt(G))*F' zeros(N,1)];
b2=[zeros(N+1,1)];
d2=sqrt(v_i);

At1 = -[b1 A1t'];
At2 = -[b2 A2t'];
At = [-D At1 At2];
bt = -b;
ct1 = [d1; c1];
ct2 = [d2; c2];
ct = [f; ct1; ct2];
K.l = size(D,2);
K.q = [size(At1,2) size(At2,2)];
[xs, ys, info] = sedumi(At,bt,ct,K);
x = ys(1:N);