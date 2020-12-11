# This test script is only to be run after the execution of Calibration_overall_test.tcl
# 
# This is clear the configure bit as well as the calibration bit in the CPLD

# ModeSel
# 0 => Red
# 1 => Green
# 2 => BOTH
# 3 => Beam

isim force add rden 0
isim force add ain 0 -radix hex
isim force add din 61 -radix hex
isim force add start 1
run 100ns
isim force add start 0
run 2us

isim force add Trig 1
run 50ns
isim force add Trig 0
run 100us

#run 2ms