function ProcessNPlotFrontier(T_0,Nu_0,Mu_0,Sigma_0,T,Mu_Hat,Sigma_Hat,NumPortf)


T_1=T_0+T;
Mu_1=(Mu_0*T_0+Mu_Hat*T)/T_1;
Nu_1=Nu_0+T;
Sigma_1=(Sigma_0*Nu_0+Sigma_Hat*T+(Mu_Hat-Mu_0)*(Mu_Hat-Mu_0)'*T_0*T/T_1)/Nu_1;


[ExpectedValue,Std_Deviation, Rel_Allocations] = EfficientFrontier(NumPortf, Sigma_1, Mu_1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
Data=cumsum(Rel_Allocations,2);
NumAssets=length(Mu_1);
for n=1:NumAssets
    x=[Std_Deviation(1); Std_Deviation; Std_Deviation(end)];
    y=[0; Data(:,NumAssets-n+1); 0];
    hold on
    h=fill(x,y,[.85 .85 .85]-mod(n,2)*[.2 .2 .2]);
end
set(gca,'xlim',[Std_Deviation(1) Std_Deviation(end)],'ylim',[0 max(max(Data))])%,'Position',[0.13 0.1 0.775 0.45])
grid on





