
restart


isim force add clock 0 -value 1 -time 10ns -repeat 20ns
isim force add Reset 1 -value 0 -time 100ns
isim force add BeamUnderEn 1 -value 0 -time 20ns -repeat 100ns

isim force add ClrFault 0

isim force add Beam_I_Under 0
isim force add Beam_I_Over  0
isim force add Beam_V_Over  0
isim force add Fwd_Over    0
isim force add Refl_Over   0

run 1us

isim force add Beam_I_Over  1
run 1us
isim force add Beam_I_Over  0

run 2us

isim force add Beam_I_Over  1
run 2us
isim force add Beam_I_Over  0

run 5us

isim force add clrfault 1
run 20ns
isim force add clrfault 0

run 5us

isim force add Beam_i_under 1
run 30us
isim force add beam_i_under 0


isim force add clrfault 1
isim force add Beam_i_under 0
run 20ns
isim force add Beam_i_under 0
isim force add clrfault 0

isim force add Beam_i_under 0
run 21us
isim force add beam_i_under 0



run 10us

