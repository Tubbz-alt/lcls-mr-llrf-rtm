
wcfg new

restart

divider add "Clocks" -color blue
wave add Clk119Mhz
wave add clkdivout

divider add "Calibration Handshake" -color blue
wave add   cal_trig Cal_done

divider add "Calibration Timing" -color blue
wave add osc_en
wave add   vpc
wave add   cl_sw(1)
wave add   cl_sw(2)
wave add   cl_sw(3)
wave add   cl_sw(4)
wave add   cl_sw(5)
wave add   cl_sw(6)

wave add Trig_Out

divider add "QSPI IO" -color blue

wave add qspi_clk qspi_Din qspi_dout
wave add ain din aout dout  -radix hex

isim force add Clk119Mhz 0 -value 1 -time 5ns -repeat 10ns

isim force add QSPI_Sys_clock 0 -value 1 -time 25ns -repeat 50ns
isim force add Reset 1 -value 0 -time 200ns

isim force add ain 0 -radix hex
isim force add din 0 -radix hex
isim force add start 0 
isim force add rden 0
isim force add cal_Trig 0
isim force add cal_ack 1

run 2us

# Write CSR0
isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 0 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 22 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us

# set Trig2beam delay
isim force add rden 0
isim force add ain 15 -radix hex
isim force add din 8 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us

# set RF2REd delay
isim force add rden 0
isim force add ain 16 -radix hex
isim force add din 9 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us

# set RF2REd delay
isim force add rden 0
isim force add ain 17 -radix hex
isim force add din A -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us


isim force add cal_Trig 1
run 50ns
isim force add cal_Trig 0
run 100us



