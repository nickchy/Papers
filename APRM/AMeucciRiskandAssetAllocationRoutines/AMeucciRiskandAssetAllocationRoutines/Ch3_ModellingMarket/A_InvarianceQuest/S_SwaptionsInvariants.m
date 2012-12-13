% this script performs the quest for invariance in the swaption market
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

clc; close all; clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs

Start='23-Oct-1998'; % later than 23-Jan-1997
Stop='7-Jul-2004';  % before 7-Jul-2004

% loads database of Dates BPvol ParRates SwaptionValue
% the data refers to the 5x5 swaption as computed by an external program
load('DB_Swaptions'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Times=find(  (Dates>=datenum(Start)) & (Dates<=datenum(Stop))  );

Dates_BPvol=Dates(Times);
BPvol=BPvol(Times);
ParRates=ParRates(Times);
SwaptionValue=SwaptionValue(Times);

figure
h=plot(Dates_BPvol,BPvol/BPvol(1));
hold on
h=plot(Dates_BPvol,SwaptionValue/SwaptionValue(1),':');
legend('implied bp vol','swaption value')
datetick('x','mmmyy','keeplimits','keepticks');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% basis point (normalized) vol analysis
IIDAnalysis(Dates_BPvol,BPvol);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% changes in basis point (normalized) volatility analysis
ChangesBPvol=BPvol(2:end)-BPvol(1:end-1);
Dates_ChangesBPvol=Dates_BPvol(2:end);
IIDAnalysis(Dates_ChangesBPvol,ChangesBPvol);
