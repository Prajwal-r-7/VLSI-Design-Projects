*** SAFF ***
.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\nmos4p0.mod"
.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\pmos4p0.mod"
*.include "C:\ngspice-44.2_64\Spice64\bin\subinv.sp"

Vpower vdd 0 1 
vgnd vss 0 0
*Vclk clk vss 1
Vd D vss 1
Vclk clk vss pulse(0 1 1n 50p 50p 0.5n 1n) 
*Vd D vss pulse(0 1 1.939n 50p 50p 1n 2n)

C1 Q 0 5f

.param wid= 0.26u


**********Db input*************
MPd db d vdd vdd P1 W='10*wid' L=0.18u
MNd db d vss vss N1 W='5*wid' L=0.18u

MP0 n1 clk vdd vdd P1 W='3.5*wid' L=0.18u 
MP1 n1 n2 vdd vdd P1 W=2u L=0.18u 
MP2 n2 n1 vdd vdd P1 W=2u L=0.18u 
MN1 n1 n2 n3 vss N1 W=2u L=0.18u 
MN2 n2 n1 n4 vss N1 W=2u L=0.18u 

MP3 n2 clk vdd vdd P1 W='3.5*wid' L=0.18u 

MN3 n3 D n5 vss N1 W='5*wid' L=0.18u 
MN4 n4 Db n5 vss N1 W='5*wid' L=0.18u 
MN5 n5 clk vss vss N1 W='25*wid' L=0.18u 

**********Q*************
MP4 Q n1 vdd vdd P1 W='5*Wid' L=0.18u 
MP5 Q Qb vdd vdd P1 W='2.4*Wid' L=0.18u
MN7 Q n1 conn1 vss N1 W='2.4*Wid' L=0.18u 
MN6 conn1 Qb vss vss N1 W='2.4*Wid' L=0.18u 

**********Qb*************
MP6 Qb n2 vdd vdd P1 W='4*Wid' L=0.18u 
MP7 Qb Q vdd vdd P1 W='1.7*Wid' L=0.18u
MN9 Qb n2 conn2 vss N1 W='1.7*Wid' L=0.18u 
MN8 conn2 Q vss vss N1 W='1.7*Wid' L=0.18u 

***inverter
MP8 Q1 Q vdd vdd P1 W=0.5u L=0.18u 
MN10 Q1 Q vss vss N1 W=0.5u L=0.18u 

.tran 10p 13n
.control

run

plot v(D) v(Q) v(clk)

meas tran totalpower AVG i(Vpower) from=1.8n to=12.2n

** rising **
*meas tran D2clk TRIG v(D) val=0.5 RISE=1 TARG v(clk) val=0.5 RISE=2
*meas tran clk2q TRIG v(clk) val=0.5 RISE=2 TARG v(Q) val=0.5 RISE=1
*meas tran D2q_rise TRIG v(D) val=0.5 RISE=1 TARG v(Q) val=0.5 RISE=1

** falling**
meas tran D2clk TRIG v(D) val=0.5 FALL=1 TARG v(clk) val=0.5 RISE=3
meas tran clk2q TRIG v(clk) val=0.5 RISE=3 TARG v(Q) val=0.5 FALL=2
meas tran D2q_fall TRIG v(D) val=0.5 FALL=1 TARG v(Q) val=0.5 FALL=2

set color0=white
set color1=black
set xbrushwidth=2.5

.endc
.end