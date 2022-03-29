# Battery Management System - Modeling 
In this project, the equivalent model of battery will be designed. The parameters that describes the battery (**State of Charge**, **Coulombic Efficiency**
, **Total Capacity**, **Diffusion Voltages**) are calculated by processing voltage and current data obtained through slow charge/discharge process. First, we will discuss the electrical components of Thevenin Model and how each component is related to the battery.

## Part 0. Thevenin Model
<p align="center">
  <img width="560" height="300" src="images/equivalent_cell.PNG">
</p>

- OCV: Open-Circuit Voltage is the voltage of the battery source which is function of z(t), state of charge.
- Ro models the polarization of the battery. Polarization is any departure of the cell's terminal voltage away from OCV due to a passage of current. v(t) > OCV during charging and v(t) < OCV during discharging.
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

## References
[1] Plett, Gregory
Algorithms for Battery Management Systems Specialization. _Coursera_
https://www.coursera.org/specializations/algorithms-for-battery-management-systems
University of Colorado Boulder
