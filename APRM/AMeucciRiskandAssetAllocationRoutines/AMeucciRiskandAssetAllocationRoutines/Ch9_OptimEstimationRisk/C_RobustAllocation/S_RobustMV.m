% this script computes the robust mean-variance allocation by means of SOCP
% the uncertainty region for the expected value is elliptical
% no uncertainty is assumed on the covariance matrix
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clc; close all; clear;

% market dimensions
N=5;

% covariance matrix of market variables
A=.2*rand(N,N); 
Sigma=A*A';

% location for Mu (expected value of market variables) 's ellipsoid
m=.4*sqrt(diag(Sigma)); 
% scatter for Mu (expected value of market variables) 's ellipsoid
A=.01*rand(N,N); 
T=A*A';
% radius of Mu (expected value of market variables) 's ellipsoid
q=1;   

% max variance allowed
v_i=mean(diag(Sigma))

% SOCP robust optimization
[x,info]=RobSocpMVPortf(m,q,T,Sigma,v_i)

% compute portfolio statistics
Exp=m'*x
Var=x'*Sigma*x
