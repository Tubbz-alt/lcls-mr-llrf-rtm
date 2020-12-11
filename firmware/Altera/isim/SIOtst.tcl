
restart
wcfg new

divider add "Calibration Handshake" -color blue
wave add   cal_init n_Cal_done

divider add "Calibration Timing" -color blue
wave add osc_on
wave add   vapc
wave add   cal_sw(1)
wave add   cal_sw(2)
wave add   cal_sw(3)
wave add   cal_sw(4)
wave add   cal_sw(5)
wave add   cal_sw(6)

divider add "QSPI IO" -color blue

wave add qspiclock rden
wave add ain din aout dout  -radix hex
wave add n_cs sclk miso

wave add {/test/u_BPM/u_BPMReg/csrreg} -radix bin

isim force add Local_clock 0 -value 1 -time 8.33ns -repeat 16.66ns
isim force add systemclk 0

isim force add QSPIclock 0 -value 1 -time 25ns -repeat 50ns
isim force add Reset 1 -value 0 -time 200ns

isim force add ain 0 -radix hex
isim force add din 0 -radix hex
isim force add start 0 
isim force add rden 0
isim force add lmtr_pulse 0
isim force add cal_init 0
isim force add rs232_rx 0
isim force add n_cal_ack 1

run 1us

# set mode to green
isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

# Read it back
isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us


# Read it back
isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us


isim force add rden 1
isim force add ain 5 -radix hex
isim force add din 55 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

isim force add rden 1
isim force add ain 5 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

run 10us

run 1us
isim force add cal_init 1
run 10ns
isim force add cal_init 0
run 5us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us

run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us
run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us
run 10us

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 40 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 5us


