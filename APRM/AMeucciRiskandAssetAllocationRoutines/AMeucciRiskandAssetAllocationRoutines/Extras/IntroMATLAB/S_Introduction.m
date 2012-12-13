%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT: 
% - set the path on the current directory 
% - help: type "helpdesk" after the prompt ">" and then enter
% - (almost) always use the ";"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clean up workspace
clear;      % clears variables, if any
close all;  % close open figures, if any
clc;        % cleans up the command window, if dirty

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define variables
NumSimul=10000; % scalar
u=[1 0 2 7];         % row-vector
uu=[1 0 2 7]';       % column-vector
uuu=[1 5 3; 2 7 8; 3 0 -1]; % matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix operations
z=u*u'+2;
w=uuu-1;  % scalars are converted into vector/matrix
zz=u.*u;  % term-by-term operations performed by the "."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user defined function
s = Addition(2,5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate random samples
x=rand(5,1);           % generates five samples from the standard uniform distribution
x=randn(NumSimul,1);   % overrides NumSimul samples from the standard normal distribution
y=lognrnd(0,1,NumSimul,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots 2D
figure   % line plot
plot(x)  % bad for i.i.d. variables

figure   % dot plot
plot(x,'.') % good for i.i.d. variables

figure   % scatter plot
plot(x,y,'.')  

figure
NumBins=round(10*log(NumSimul));
hist(x,NumBins)     % visualize a distribution (pdf) with a histogram

% define a transformation of a vector: bad way...
y=zeros(NumSimul,1); % non-necessary initialization
for j=1:NumSimul     % non-necessary, time-consuming loop
    y(j)=normcdf(x(j));
end

% ...and good way
yy=normcdf(x);

% generate multi-variate random samples
mu=[0; 0];
Sigma=[1 0.8;0.8 1]; % 
R = mvnrnd(mu,Sigma,NumSimul);

% plots
figure
R_1=R(:,1);
R_2=R(:,2);
plot(R_1,R_2,'.') % scatter plot

% visualize a distribution (pdf) with a histogram
figure
NumBins2D=[30 30];
hist3(R,NumBins2D)     

% visualize a surface
X_axis=[-1 : 0.1 : 1];
Y_axis=[-1.1 : 0.1 : 1.1];
[X,Y]=meshgrid(X_axis,Y_axis);
Z=X.*Y;  % entry-by-entry multiplication
figure
surf(X,Y,Z)