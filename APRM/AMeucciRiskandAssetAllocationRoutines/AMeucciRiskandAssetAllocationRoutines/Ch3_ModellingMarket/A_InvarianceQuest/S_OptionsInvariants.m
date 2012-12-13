% this script performs the quest for invariance in the option market
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci


clc; close all; clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% percentage volatility analysis

Start='5-Feb-1990'; % later than Jan 5th 1990
Stop='7-Aug-1998';  % before Dec 29th 2000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('DB_VIX'); % loads Dates, SPX and Vix (vectors of doubles)
Times=find(  (Dates>=datenum(Start)) & (Dates<=datenum(Stop))  );
Dates=Dates(Times);
SPX=SPX(Times);
Vix=Vix(Times);


figure
h=plot(Dates,Vix/Vix(1));
hold on
h=plot(Dates,SPX/SPX(1));
legend('Vix','S&P500')
datetick('x','mmmyy','keeplimits','keepticks');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% percentage volatility analysis
ATMFvol=Vix;
Dates_ATMFvol=Dates(1:end);
IIDAnalysis(Dates_ATMFvol,ATMFvol);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% changes in percentage volatility analysis
ChangesATMFvol=Vix(2:end)-Vix(1:end-1);
Dates_ChangesATMFvol=Dates(2:end);
IIDAnalysis(Dates_ChangesATMFvol,ChangesATMFvol);