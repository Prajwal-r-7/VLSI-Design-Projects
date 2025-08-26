*** Efficient MSFF ***

.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\nmos4p0.mod"
.include "C:\ngspice-44.2_64\Spice64\examples\soi\bsim4soi\pmos4p0.mod"

Vpower vdd 0 1 
vgnd vss 0 0
Vgate1 clk vss pulse(0 1 1n 50p 50p 0.5n 1n) 
Vgate Data vss pulse(0 1 1.864n 50p 50p 1n 2n)

.PARAM wid_np=0.3u

C1 out5 vss 5f

**clock inverter
MP10 clkb clk vdd vdd P1 W=20u L=0.18u  
MN11 clkb clk vss vss N1 W=20u L=0.18u

**INVERTER AT D INPUT 
MP8 DB Data vdd vdd P1 W='30*wid_np' L=0.18u  
MN8 DB Data vss vss N1 W='15*wid_np' L=0.18u 

** master
MP0 out1 clk DB vdd P1 W='21*wid_np' L=0.18u  
MN0 DB clkb out1 vss N1 W='10*wid_np' L=0.18u 

MP1 out2 out1 vdd vdd P1 W=2u L=0.18u  
MN1 out2 out1 vss vss N1 W=1u L=0.18u

MP2 net1 clkb vdd vdd P1 W=2u L=0.18u
MP3 out1 out2 net1 vdd P1 W=2u L=0.18u  
MN2 net2 clk vss vss N1 W=1u L=0.18u   
MN3 out1 out2 net2 vss N1 W=1u L=0.18u 

**slave
MP4 out3 clkb out1 vdd P1 W='10*wid_np' L=0.18u  
MN4 out1 clk out3 vss N1 W='8*wid_np' L=0.18u 

MP5 out4 out3 vdd vdd P1 W=2u L=0.18u  
MN5 out4 out3 vss vss N1 W=1u L=0.18u 

MP6 net3 clk vdd vdd P1 W=2u L=0.18u
MP7 out3 out4 net3 vdd P1 W=2u L=0.18u  
MN6 net4 clkb vss vss N1 W=1u L=0.18u   
MN7 out3 out4 net4 vss N1 W=1u L=0.18u 

**INVERTER AT Q OUTPUT
MP9 out5 out3 vdd vdd P1 W='2*wid_np' L=0.18u  
MN9 out5 out3 vss vss N1 W='1*wid_np' L=0.18u 

.tran 10p 14n
.control
run
plot v(Data) v(clk) V(OUT5)

meas tran totalpower AVG i(Vpower) from=1.8n to=12.3n

*meas tran D_clk_set TRIG v(Data) val=0.5 RISE=1 TARG v(clk) val=0.5 RISE=2
*meas tran clk_q TRIG v(clk) val=0.5 RISE=2 TARG v(out5) val=0.5 RISE=1
*meas tran D_Q TRIG v(Data) val=0.5 RISE=1 TARG v(out5) val=0.5 RISE=1

meas tran D_clk_set_FALL TRIG v(Data) val=0.5 FALL=1 TARG v(clk) val=0.5 RISE=3
meas tran clk_q_FALL TRIG v(clk) val=0.5 RISE=3 TARG v(out5) val=0.5 FALL=2
meas tran D_Q_FALL TRIG v(Data) val=0.5 FALL=1 TARG v(out5) val=0.5 FALL=2

set color0=white
set color1=black
set xbrushwidth=2.5

.endc
.end		