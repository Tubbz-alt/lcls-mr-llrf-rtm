# Calibration sequencer test

restart


isim force add clk119mhz 0 -value 1 -time 20ns -repeat 50ns
isim force add Reset 1 -value 0 -time 50ns

run 100ns

# write
isim force add ain 0 -radix hex
isim force add din 55 -radix hex
isim force add start 1
isim force add rden 0
run 100ns
isim force add start 0
run 10us

# read
isim force add ain 0 -radix hex
isim force add din 00 -radix hex
isim force add start 1
isim force add rden 1
run 200ns
isim force add start 0
run 10us


