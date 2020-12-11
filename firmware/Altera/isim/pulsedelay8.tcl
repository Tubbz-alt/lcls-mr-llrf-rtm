# Testing Pulse Delay 8

wave add {/bpm_atest/uut/u_cal_seq/u_Pulse}

isim force add clock 0 -value 1 -time 20ns -repeat 40ns
isim force add Reset 1 -value 0 -time 10ns
run 10ns
isim force add delay 10 -radix hex
run 20ns
isim force add triggerin 1

# Long pulse
run 1us
isim force add triggerin 0

# Short pulse
#run 50ns
#isim force add triggerin 0

run 2us
