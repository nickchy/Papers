figure 

% compute budget constraint
[E,V,MV_ExpectedValue,MV_Variance,SR_ExpectedValue,SR_Variance]=ComputeFrontier(Market,InvestorProfile,[9800 11000]);
% compute var-constraint line
Var_ConstraintLine = (1-InvestorProfile.BudgetAtRisk)*InvestorProfile.Budget + sqrt(2*V)*erfinv(2*InvestorProfile.Confidence-1);
% compute and plot feasible set
[a,Index]=find(E>=Var_ConstraintLine);
Bottom=min(E(Index));Top=max(E(Index));
[a,Indexx]=find( (Var_ConstraintLine<=Top)  &  (Var_ConstraintLine>=Bottom) ); 
Indexx=intersect(Index,Indexx);

E_1=Var_ConstraintLine(Indexx);
V_1=V(Indexx);
E_2=E(Index);
V_2=V(Index);

[E_1,Sort_Index]=sort(E_1);
V_1=V_1(Sort_Index);
[aa,Sort_Index]=sort(-E_2);
E_2=E_2(Sort_Index);
V_2=V_2(Sort_Index);

Fill_y=[E_1 E_2];
Fill_x=[V_1 V_2 ];
hold on
h=fill(Fill_x,Fill_y,[.7 .7 .7]);
hold on
h=plot(V,E);
set(h,'linewidth',2,'color','k');
hold on
h=plot(V,Var_ConstraintLine);
set(h,'linewidth',2,'color','k');

% plot ideal true coordiates
hold on
h=plot(Optimal_Variance,Optimal_ExpectedValue,'.');
set(h,'markersize',20,'color','k');
% plot optimal iso-satisfaction
Optimal_SatisfactionLine = Optimal_CE + V/(2*InvestorProfile.RiskPropensity);
hold on
h=plot(V,Optimal_SatisfactionLine);
set(h,'linewidth',1,'color','k');

% plot true coordinates 
hold on
h=plot(Store_PseudoOptimal_Variance,Store_PseudoOptimal_ExpectedValue,'.');
set(h,'markersize',5,'color','k');

Leeway=.1;
X_Low=min(V); X_High=max(V_2);
X_Lim=[X_Low-Leeway*(X_High-X_Low) X_High+Leeway*(X_High-X_Low)];
Y_Low=min(E_2); Y_High=max(E_2);
Y_Lim=[Y_Low-Leeway*(Y_High-Y_Low) Y_High+Leeway*(Y_High-Y_Low)];
set(gca,'xlim',X_Lim,'ylim',Y_Lim);
grid on
