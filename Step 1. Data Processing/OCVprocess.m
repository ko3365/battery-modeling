clc;clear;close;
load ..\data\E2_OCV_P25.mat

totDisAh = OCVData.script1.disAh(end) + OCVData.script2.disAh(end) + ...
           OCVData.script3.disAh(end) + OCVData.script4.disAh(end);
totChgAh = OCVData.script1.chgAh(end) + OCVData.script2.chgAh(end) + ...
           OCVData.script3.chgAh(end) + OCVData.script4.chgAh(end);
eta25 = totDisAh/totChgAh;

Q25 = OCVData.script1.disAh(end) + OCVData.script2.disAh(end) - ...
      OCVData.script1.chgAh(end) - OCVData.script2.chgAh(end);

SOC = 0:0.005:1; 

indD  = find(OCVData.script1.step == 2); % slow discharge
IR1Da = OCVData.script1.voltage(indD(1)-1) - OCVData.script1.voltage(indD(1));
IR2Da = OCVData.script1.voltage(indD(end)+1) - OCVData.script1.voltage(indD(end));

indC  = find(OCVData.script3.step == 2); % slow charge
IR1Ca = OCVData.script3.voltage(indC(1)) - OCVData.script3.voltage(indC(1)-1);
IR2Ca = OCVData.script3.voltage(indC(end)) - OCVData.script3.voltage(indC(end)+1);
IR1D = min(IR1Da,2*IR2Ca); IR2D = min(IR2Da,2*IR1Ca);
IR1C = min(IR1Ca,2*IR2Da); IR2C = min(IR2Ca,2*IR1Da);

blend = (0:length(indD)-1)/(length(indD)-1);
IRblend = IR1D + (IR2D-IR1D)*blend(:);
disV = OCVData.script1.voltage(indD) + IRblend;
disZ = 1 - OCVData.script1.disAh(indD)/Q25;
disZ = disZ + (1 - disZ(1));
Vdischarge = OCVData.script1.voltage(indD);

blend = (0:length(indC)-1)/(length(indC)-1);
IRblend = IR1C + (IR2C-IR1C)*blend(:);
chgV = OCVData.script3.voltage(indC) - IRblend;
chgZ = OCVData.script3.chgAh(indC)/Q25;
chgZ = chgZ - chgZ(1);
Vcharge = OCVData.script3.voltage(indC);

deltaV50 = interp1(chgZ,chgV,0.5) - interp1(disZ,disV,0.5);
ind = find(chgZ < 0.5);
vChg = chgV(ind) - chgZ(ind)*deltaV50;
zChg = chgZ(ind);
ind = find(disZ > 0.5);
vDis = flipud(disV(ind) + (1 - disZ(ind))*deltaV50);
zDis = flipud(disZ(ind));
rawocv = interp1([zChg; zDis],[vChg; vDis],SOC,'linear','extrap');

figure(2)
hold on
plot(disZ,Vdischarge)
plot(chgZ,Vcharge)
plot(SOC,rawocv)
xlabel('SOC')
ylabel('Voltage (V)') 
grid on
title('OCV as a function of SOC at 25^oC')
legend('Discharge V','Charge V','Merged V')
hold off