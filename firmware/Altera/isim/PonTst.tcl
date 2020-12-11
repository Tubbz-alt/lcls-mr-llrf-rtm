
restart

# Tuned 0x31
# DeTuned 0x0E


isim force add clock 0 -value 1 -time 4ns -repeat 8ns
isim force add Reset 1 -value 0 -time 100ns
isim force add Trigger 0 -value 1 -time 10ns -value 0 -time 64ns -repeat 1us

isim force add n_Tune_Req 1
isim force add n_DeTune_Req 1

isim force add clrfault 0
isim force add bypass 0
isim force add n_beam_i_under 1


 #Tuned
isim force add n_Lower_Tuned			0
isim force add n_Upper_Tuned			0
isim force add n_Motor_Not_Tuned		1
isim force add n_Lower_Detuned		1
isim force add n_Upper_Detuned		1
isim force add n_Motor_Not_Detuned	0


isim force add cmd_sdi 0
isim force add n_cmd_cs 1
isim force add cmd_clk 0

isim force add n_beam_i_under 1
isim force add beam_i_over 0
isim force add beam_v_over 0
isim force add fwd_over 0
isim force add refl_over 0
isim force add n_tune_req 1
isim force add n_detune_req
isim force add mod_fault 0
isim force add mode 0

isim force add spare_in 0
isim force add slow_in0 0
isim force add slow_in1 0


run 20ms

isim force add clrfault 1
run 100ns
isim force add clrfault 0

run 100us

