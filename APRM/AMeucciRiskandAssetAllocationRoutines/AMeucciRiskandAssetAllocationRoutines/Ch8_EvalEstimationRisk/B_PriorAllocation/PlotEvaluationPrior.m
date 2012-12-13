figure 

subplot(3,1,1)
h=plot(Overall_Correlations,Suboptimal.StrsTst_Satisfaction,'o');
set(h,'markerfacecolor','k','markeredgecolor','k')
hold on
h=plot(Overall_Correlations,Optimal.StrsTst_Satisfaction,'o');
set(h,'markerfacecolor','w','markeredgecolor','k')
grid on
legend('maximum','prior','location','northeast')
title('satisfaction')

subplot(3,1,2)
h=plot(Overall_Correlations,Suboptimal.StrsTst_CostConstraints,'o');
set(h,'markerfacecolor','k','markeredgecolor','k')
grid on
title('cost of constraint violation')

subplot(3,1,3)
h=plot(Overall_Correlations,Suboptimal.StrsTst_OppCost,'o');
set(h,'markerfacecolor','k','markeredgecolor','k')
grid on
title('opportunity cost')

