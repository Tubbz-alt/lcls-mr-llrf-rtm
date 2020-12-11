# Calibration sequencer test
wcfg new

restart


isim force add clock 0 -value 1 -time 20ns -repeat 50ns
isim force add Reset 1 -value 0 -time 50ns
isim force add trig_en 1
isim force add trig_feen 1
isim force add trig_in 0

run 100ns

isim force add trig_in 1
run 100ns
isim force add trig_in 0

run 200ns


