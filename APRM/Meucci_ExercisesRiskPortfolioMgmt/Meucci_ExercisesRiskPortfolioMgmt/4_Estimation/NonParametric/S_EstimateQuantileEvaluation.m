% this script familiarizes the user with the evaluation of an estimator:
% replicability, loss, error, bias and inefficiency
% see "Risk and Asset Allocation"- Springer (2005), by A. Meucci

clear;  close all;  clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=52;

a=.8;
m_Y=.1;
s_Y=.2;
m_Z=0;
s_Z=.15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plain estimation

% functional of the distribution to be estimated
G_fX =QuantileMixture(0.5,a,m_Y,s_Y,m_Z,s_Z);

% series generated by "nature": do not know the distribution
P=rand(T,1)';
i_T=QuantileMixture(P,a,m_Y,s_Y,m_Z,s_Z);

Ge=G_Hat_e(i_T)        % tentative estimator of unknown functional
Gb=G_Hat_b(i_T)        % tentative estimator of unknown functional

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% replicability vs. "luck"

% functional of the distribution to be estimated
G_fX =QuantileMixture(0.5,a,m_Y,s_Y,m_Z,s_Z);

% randomize series generated by "nature" to check replicability
Num_Simulations=10000;
I_T=[];
for t=1:T
    P=rand(Num_Simulations,1);
    Simul=QuantileMixture(P,a,m_Y,s_Y,m_Z,s_Z);
    I_T=[I_T Simul];
end

Ge=G_Hat_e(I_T);        % tentative estimator of unknown functional
Gb=G_Hat_b(I_T);        % tentative estimator of unknown functional

Loss_Ge=(Ge-G_fX).^2;
Loss_Gb=(Gb-G_fX).^2;

Err_Ge=sqrt(mean(Loss_Ge));
Err_Gb=sqrt(mean(Loss_Gb));

Bias_Ge=abs(mean(Ge)-G_fX);
Bias_Gb=abs(mean(Gb)-G_fX);

Ineff_Ge=std(Ge);
Ineff_Gb=std(Gb);

%estimators
figure 
NumBins=round(10*log(Num_Simulations));

subplot(2,1,1)
hist(Ge,NumBins)
hold on
h=plot(G_fX,0,'.');
set(h,'color','r')
title('estimator e')

subplot(2,1,2)
hist(Gb,NumBins)
hold on
h=plot(G_fX,0,'.');
set(h,'color','r')
title('estimator b')

%loss
figure 
subplot(2,1,1)
hist(Loss_Ge,NumBins)
title('loss of estimator e')
subplot(2,1,2)
hist(Loss_Gb,NumBins)
title('loss of estimator b')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stress test replicability
m_s=[0 : .02 : 0.2];

Err_Gesq=[];Bias_Gesq=[];Ineff_Gesq=[];
Err_Gbsq=[]; Bias_Gbsq=[]; Ineff_Gbsq=[];

for j=1:length(m_s)
    m_Y=m_s(j);
    % functional of the distribution to be estimated
    G_fX =QuantileMixture(0.5,a,m_Y,s_Y,m_Z,s_Z);

    % randomize series generated by "nature" to check replicability
    Num_Simulations=10000;
    I_T=[];
    for t=1:T
        P=rand(Num_Simulations,1);
        Simul=QuantileMixture(P,a,m_Y,s_Y,m_Z,s_Z);
        I_T=[I_T Simul];
    end

    Ge=G_Hat_e(I_T);        % tentative estimator of unknown functional
    Gb=G_Hat_b(I_T);        % tentative estimator of unknown functional

    Loss_Ge=(Ge-G_fX).^2;
    Loss_Gb=(Gb-G_fX).^2;

    Err_Ge=sqrt(mean(Loss_Ge));
    Err_Gb=sqrt(mean(Loss_Gb));

    Bias_Ge=abs(mean(Ge)-G_fX);
    Bias_Gb=abs(mean(Gb)-G_fX);

    Ineff_Ge=std(Ge);
    Ineff_Gb=std(Gb);

    %store results
    Err_Gesq=[Err_Gesq Err_Ge^2];
    Err_Gbsq=[Err_Gbsq Err_Gb^2];
    
    Bias_Gesq=[Bias_Gesq Bias_Ge^2]; 
    Bias_Gbsq=[Bias_Gbsq Bias_Gb^2]; 
    
    Ineff_Gesq=[Ineff_Gesq Ineff_Ge^2]; 
    Ineff_Gbsq=[Ineff_Gbsq Ineff_Gb^2]; 


end

figure

subplot(2,1,1)
h=bar(Bias_Gesq'+Ineff_Gesq','r');
hold on
h=bar(Ineff_Gesq');
hold on
h=plot(Err_Gesq);
legend('bias^2','ineff.^2','error^2','location','best')
title('stress-test of estimator e')

subplot(2,1,2)
h=bar(Bias_Gbsq'+Ineff_Gbsq','r');
hold on
h=bar(Ineff_Gbsq');
hold on
h=plot(Err_Gbsq);
legend('bias^2','ineff.^2','error^2','location','best')
title('stress-test of estimator b')
