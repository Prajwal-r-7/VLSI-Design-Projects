*** HLFF *** 
.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\nmos4p0.mod"
.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\pmos4p0.mod"
.include "C:\ngspice-44.2_64\Spice64\bin\subinv.sp"

Vpower vdd 0 1
vgnd vss 0 0
*Vclk clk vss 1
*Vd d vss 1
Vclk clk vss pulse(0 1 1n 50p 50p 0.5n 1n) 
Vd d vss pulse(0 1 1.923n 50p 50p 1n 2n) 

C1 q 0 5f

.param wid = 1.4

**** db ****
MPd db d vdd vdd P1 W=10u L=0.18u
MNd db d vss vss N1 W=7u L=0.18u

**** inverter stages ****
Xinv1 clk out1 vdd vss inv
Xinv2 out1 out2 vdd vss inv 
Xinv3 out2 clkb vdd vss inv 
*Xinv3 out2 out3 vdd vss inv 
*Xinv4 out3 out4 vdd vss inv 
*Xinv5 out4 clkb vdd vss inv 


**** cirucit connections ****
MP1 x clk vdd vdd P1 W='wid*7u' L=0.18u
MN1 x clk n1 vss N1 W='wid*5.5u' L=0.18u
MN2 n1 db n2 vss N1 W='wid*5.5u' L=0.18u
MN3 n2 clkb vss vss N1 W='wid*5.5u' L=0.18u

MP2 x db vdd vdd P1 W=4u L=0.18u

MP3 x clkb vdd vdd P1 W=3u L=0.18u

MP4 q x vdd vdd P1 W='wid*5u' L=0.18u
MN4 q clk n4 vss N1 W='wid*3.5u' L=0.18u
MN5 n4 x n5 vss N1 W='wid*3.5u' L=0.18u
MN6 n5 clkb vss vss N1 W='wid*3.5u' L=0.18u

**** keeper circuit ****
MPki q1 q vdd vdd P1 W=2u L=0.18u
MNki q1 q vss vss N1 W=1u L=0.18u

MPkt1 t1 clkb vdd vdd P1 W=2u L=0.18u
MPkt2 q q1 t1 vdd P1 W=2u L=0.18u
MNkt1 q q1 t2 vss N1 W=1u L=0.18u
MNkt2 t2 clk vss vss N1 W=1u L=0.18u

**** last inverter ****
MPlinv qb q vdd vdd P1 W=8u L=0.18u
MNlinv qb q vss vss N1 W=6u L=0.18u

.tran 10p 13n
.control
run
*plot v(clk) v(clkb)
plot v(d) v(qb) v(clk)

meas tran pulse_width TRIG v(clk) val=0.5 RISE=2 TARG v(clkb) val=0.5 FALL=2

*rising 
*meas tran d2clk TRIG v(d) val=0.5 RISE=1 TARG v(clk) val=0.5 RISE=2
*meas tran clk2q TRIG v(clk) val=0.5 RISE=2 TARG v(qb) val=0.5 RISE=1
*meas tran d2q_rising TRIG v(d) val=0.5 RISE=1 TARG v(qb) val=0.5 RISE=1

*falling
meas tran d2clk TRIG v(d) val=0.5 FALL=1 TARG v(clk) val=0.5 RISE=3
meas tran clk2q TRIG v(clk) val=0.5 RISE=3 TARG v(qb) val=0.5 FALL=1
meas tran d2q_falling TRIG v(d) val=0.5 FALL=1 TARG v(qb) val=0.5 FALL=1

meas tran totalpower AVG i(Vpower) from=1.8n to=12.2n

set color0=white
set color1=black
set xbrushwidth=2.5
.endc
.end
 


