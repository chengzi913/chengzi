*Reference latch
*参数设置
.param SUPPLY=1v
.param H=1
.option scale=45nm
.include"D:\study\hspice2015\Model\PTM\45nm_bulk.pm"
.temp 25
.option post brief NOMOD


*传输门
.subckt TRANS CK CKF a2 y2
MN5 y2 CK a2  gnd NMOS W="H*2"  L="H*1"
MP5 y2 CKF a2 vdd PMOS W="H*4"  L="H*1"
.ends

*传输管
.subckt PIP CK1 a3 y3
    MN6 y3 CK1 a3 gnd NMOS W="H*4"  L="H*1"
.ends

*DICE
.subckt DICE DI1 DI2 DI3 DI4 
    MP1 DI2 DI1 vdd vdd PMOS W='H*2'  L='H*1'
    MP2 DI3 DI2 vdd vdd PMOS W='H*2'  L='H*1'
    MP3 DI4 DI3 vdd vdd PMOS W='H*2'  L='H*1'
    MP4 DI1 DI4 vdd vdd PMOS W='H*2'  L='H*1'
    
    MN1 DI4 DI1 gnd gnd NMOS W='H*1'  L='H*1'
    MN2 DI3 DI4 gnd gnd NMOS W='H*1'  L='H*1'
    MN3 DI2 DI3 gnd gnd NMOS W='H*1'  L='H*1'
    MN4 DI1 DI2 gnd gnd NMOS W='H*1'  L='H*1'
.ends

*网表
X1   CLK CLKB  D   N1  TRANS 
X2   CLK CLKB D N3 TRANS 
*X1 CLK D N1 PIP
*X2 CLK D N3 PIP
X3 N1 N2 N3 N4 DICE



Vdd vdd gnd 'SUPPLY'
.global vdd gnd 

*激励

Vin1 D        GND    PULSE   0   'SUPPLY'      0ps      0ps     0ps    2000ps      4000ps 
Vin2 CLK      GND    PULSE      0   'SUPPLY'    0ps      0ps     0ps   5000ps      10000ps
Vin3 CLKB      GND    PULSE        'SUPPLY'   0   0ps      0ps     0ps   5000ps      10000ps

*.measure  charge  INTEGRAL  I(vdd)  FROM=0ns  TO=10ns 
*.measure  energy  param='charge*SUPPLY' 
*.print    P(vdd)  
*.measure  pwr  AVG  P(vdd)  FROM=0ns  TO=10ns


*故障注入实质
*------------------------------------------
*.param T1    =     100e-12
*.param T2    =     5e-12
*-------------------------------------------
*111111111111111111111
*---------------------------------------------
*.param TSN1= 6.5ns
*.param QseuN1= -15e-11
*GiseuN1 N2  gnd  CUR='0.5*(1+sgn(time-tsN1))*(QseuN1/(T2 - T1))*(exp((tsN1-time)/T2)-exp((tsN1-time)/T1))'
.param TS1= 6.5e-9
.param Qseu  =-20e-15    
**SEU注入的电荷量，单位c
.param T1    =  100e-12        
**SEU注入的参数τ1，离子轨迹建立常数，单位s
.param T2    =    5e-12           
**SEU注入的参数τ2，电荷聚集时间常数，单位s 
Giseu1   N2  gnd   CUR='0.5*(1+sgn(time-ts1))* (Qseu/(T2 - T1))*(exp((ts1-time)/T2)-exp((ts1-time)/T1))'



.tran 0.01ps 15ns
.end