# Battery Management System - Modeling 
In this project, the equivalent model of battery will be designed. The parameters that describes the battery (**State of Charge**, **Coulombic Efficiency**
, **Total Capacity**, **Diffusion Voltages**) are calculated by processing voltage and current data obtained through slow charge/discharge process. First, we will discuss the electrical components of Thevenin Model and how each component is related to the battery.

## Part 0. Thevenin Model
<p align="center">
  <img width="560" height="300" src="images/equivalent_cell.PNG">
</p>

- OCV: Open-Circuit Voltage is the voltage of the battery source which is function of z(t), state of charge.
- Ro models the polarization of the battery. Polarization is any departure of the cell's terminal voltage away from OCV due to a passage of current. v(t) > OCV for charging and v(t) < OCV for discharging.
- The capacitor and resistor in parallel models the dynamic response of the voltage (diffusion voltage).

### (i) State of Charge (z = 1 when fully charged, z = 0 when fully discharged)
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\frac{dz}{dt}&space;=&space;-i(t)/Q&space;}">
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;z(t)&space;=&space;z(t_o)-\frac{1}{Q}\int_{t_o}^t{i(\tau)d\tau}}">

### (ii) Coulombic Efficiency
Assume the efficiency is 1 on discharge and less than 1 on charge. This represents the energy loss during the charging process. Thus, 

<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\frac{dz}{dt}&space;=&space;-i(t)\eta(t)/Q&space;}&space;">

### (iii) Output Voltage
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;v(t)&space;=&space;OCV(z(t))-&space;R_1i_{R1}(t)-R_oi(t)}&space;">

### (iv) Capacitor Current
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;i(t)=i_{R1}(t)&plus;C_1\dot{v_{C1}}(t),&space;\&space;\&space;v_{C1}(t)=i_{R1}(t)R_1}&space;">
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\frac{di_{R1}(t)}{dt}&space;=&space;-\frac{1}{R_1C_1}i_{R1}(t)&plus;\frac{1}{R_1C_1}i(t)}&space;">

### State Space Model:
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\frac{dz(t)}{dt}=-\frac{\eta(t)}{Q}i(t)}&space;">
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\frac{di_{R1}(t)}{dt}=-\frac{1}{R_1C_1}i_{R1}(t)&plus;\frac{1}{R_1C_1}i(t)}">
<img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;v(t)=OCV(z(t))&space;-&space;R_1i_{R1}(t)-R_oi(t)}">

## Part 1. Data Processing
Data is collected by slowly charging/discharging the cell to max/min voltage (specified by manufacture). Voltage, current, accumulated Ah charged, accumulated Ah discharged are recorded regularly.

- Script 1: Discharge the cell at temperature T
  - Step 1: Soak at temperature T for at least 2 hours
  - Step 2: Discharge the cell at C/30 rate until minimum voltage is reached
- Script 2: Discharge the cell at temperature 25C
  - Step 3: Soak at temperature 25C for at least 2 hours
  - Step 4: Discharge the cell at C/30 rate until minimum voltage is reached
- Script 3: Charge the cell at temperature T
  - Step 5: Soak at temperature T for at least 2 hours
  - Step 6: Charge the cell at C/30 rate until maximum voltage is reached
- Script 4: Charge the cell at temperature 25C
  - Step 7: Soak at temperature 25C for at least 2 hours
  - Step 8: Charge the cell at C/30 rate until maximum voltage is reached
 
 time, step, current, voltage, chgAh, and disAH are stored in data for each script, and data can be obtained by:
 ```Matlab
 load ../Data/E2_OCV_P25.mat
 %script 1 time data
 OCVData.script1.time
 %script 2 current data
 OCVData.script2.current
 %script 3 voltage data
 OCVData.script3.voltage
 %script 1 acummulated Ah discharged
 OCVData.script1.disAh
 %script 3 accumuluated Ah charged
 OCVData.script3.chgAh
 ```
 
 ### Determining Coulombic Efficiency
 Because we discharge to 0% and charge back to 100%, the initial and end state of state of charge is equal to 100%. Start with the data processed for temperature T=25.
 
 <img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;z[k]&space;=&space;z[0]-\frac{1}{Q}\sum_{j=0}^{k-1}&space;\eta[j]i[j],&space;\&space;\&space;z[k]=z[0]=100%&space;}">
 
 Split the summation into discharging and charging sets:
 
 <img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\sum_{discharge}i[j]&plus;\sum_{charge}\eta[j]i[j]&space;=&space;0}">
 
 <img src="https://latex.codecogs.com/svg.image?\large&space;{\color{Gray}&space;\eta(25^oC)=\frac{\text{Total&space;Ah&space;Discharged}}{\text{Total&space;Ah&space;Charged}}}">
 
```Matlab
totDisAh = OCVData.script1.disAh(end) + OCVData.script2.disAh(end) + ...
           OCVData.script3.disAh(end) + OCVData.script4.disAh(end);
totChgAh = OCVData.script1.chgAh(end) + OCVData.script2.chgAh(end) + ...
           OCVData.script3.chgAh(end) + OCVData.script4.chgAh(end);
couleff25 = totDisAh/totChgAh
```


## References
[1] Plett, Gregory
Algorithms for Battery Management Systems Specialization. _Coursera_
https://www.coursera.org/specializations/algorithms-for-battery-management-systems
University of Colorado Boulder
