
restart

isim force add clk119mhz 0 -value 1 -time 8.33ns -repeat 16.66ns
isim force add Reset 1 -value 0 -time 100ns

isim force add cal_trig 0
isim force add beam_trig 0
isim force add cal_ack 0
isim force add n_qspi_cs 0
isim force add qspi_clk 0
isim force add qspi_din 0

run 1us

isim force add /bpm_atest/uut/u_BPMReg/trig2beam 1 -radix hex

isim force add /bpm_atest/uut/u_BPMReg/rf2red 7f   -radix hex
isim force add /bpm_atest/uut/u_BPMReg/rf2green 10   -radix hex

isim force add /bpm_atest/uut/modesel 0 -radix hex

run 1us
isim force add beam_trig 1
run 20ns
isim force add beam_trig 0
run 10us


run 1us
isim force add cal_trig 1
run 20ns
isim force add cal_trig 0
run 30us
isim force add cal_ack 1
run 20ns
isim force add cal_ack 0
run 10us


isim force add /bpm_atest/uut/modesel 1 -radix hex

run 1us
isim force add cal_trig 1
run 20ns
isim force add cal_trig 0
run 30us
isim force add cal_ack 1
run 20ns
isim force add cal_ack 0
run 10us

isim force add /bpm_atest/uut/modesel 2 -radix hex

run 1us
isim force add cal_trig 1
run 20ns
isim force add cal_trig 0
run 30us
isim force add cal_ack 1
run 20ns
isim force add cal_ack 0
run 10us


isim force add /bpm_atest/uut/u_BPMReg/trig2amp        20 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/amp2rf1         2 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/rf12rf2         2 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/rfwidth         10 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/offtime         2 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/trig2beam       2 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/rf2red          2 -radix hex
isim force add /bpm_atest/uut/u_BPMReg/rf2green        2 -radix hex
run 1us
isim force add cal_trig 1
run 20ns
isim force add cal_trig 0
run 30us
isim force add cal_ack 1
run 20ns
isim force add cal_ack 0
run 10us

